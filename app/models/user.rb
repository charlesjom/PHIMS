require "openssl"
require "base64"

class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable

  validates_presence_of   :email, :first_name, :last_name
  validates_format_of     :email, with: URI::MailTo::EMAIL_REGEXP
  validates_uniqueness_of :username, :email
  validates_length_of     :first_name, :middle_name, :last_name, maximum: 30, allow_nil: true
  validates_acceptance_of :tac_acceptance

  before_create :generate_identifier
  before_create :generate_user_keys
  
  # Model associations
  has_many :share_keys, dependent: :destroy
  has_many :user_records, dependent: :destroy

  def fullname
    [first_name, middle_name, last_name].join(" ")
  end

  def records_with_access
    ids = share_keys.pluck(:user_record_id)
    UserRecord.where(id: ids)
  end

  def update_with_password(params, *options)
    current_password = params.delete(:current_password)
    new_password = params.fetch(:password, nil)
    new_password_confirmation = params.fetch(:password_confirmation, nil)

    if params[:password].blank?
      params.delete(:password)
      params.delete(:password_confirmation) if params[:password_confirmation].blank?
    end

    result = if valid_password?(current_password)
      begin
        temp_result = update(params, *options)  
        update_user_keys(current_password, new_password) if temp_result && new_password.present?
        temp_result
      rescue => e
        Rails.logger.error e.message
      end
    else
      assign_attributes(params, *options)
      valid?
      errors.add(:current_password, current_password.blank? ? :blank : :invalid)
      false
    end

    clean_up_passwords
    result
  end

  def reset_password(new_password, new_password_confirmation)
    result = super

    generate_new_user_keys if result
  end

  private

  def generate_identifier
    self.identifier = "USER-#{DateTime.now.to_s(:number)}"
  end

  def generate_user_keys
    keypair = OpenSSL::PKey::RSA.new(4096)

    cipher = OpenSSL::Cipher::AES256.new(:CBC)
    cipher.encrypt # set to encryption mode
    key = cipher.random_key
    iv = cipher.random_iv

    self.encrypted_private_key = Base64.encode64(keypair.export(cipher, self.password))
		self.public_key = keypair.public_key
  end

  def update_user_keys(current_password, new_password)
    Rails.logger.debug "Updating user keys..."
    # save current encrypted private key that will be used in updating records and share keys later
    current_encrypted_private_key = Base64.decode64(self.encrypted_private_key)
    
    # decrypt current private key using current password
    keypair = OpenSSL::PKey::RSA.new(current_encrypted_private_key, current_password)
    cipher = OpenSSL::Cipher::AES256.new(:CBC)
    cipher.encrypt # set to encryption mode
    key = cipher.random_key
    iv = cipher.random_iv
    
    # re-encrypt private key with new password
    self.encrypted_private_key = Base64.encode64(keypair.export(cipher, new_password))
    save
    update_owned_records(current_encrypted_private_key, current_password)
    update_share_keys(current_encrypted_private_key, current_password)
  rescue => e
    raise e
    Rails.logger.error "Error in updating user keys"
  end

  def generate_new_user_keys
    # generate new user keys using new password
    generate_user_keys
    save
    # delete all user records and share keys since it can't be decrypted anymore
    user_records.delete_all
    share_keys.delete_all
  end

  def update_owned_records(encrypted_private_key, current_password)
    Rails.logger.debug "Updating owned records..."
    user_records.each do |user_record|
      encrypted_file_key = Base64.decode64(user_record.encrypted_file_key)
      private_key = OpenSSL::PKey::RSA.new(Base64.decode64(encrypted_private_key), current_password)
      file_key = private_key.private_decrypt(encrypted_file_key)

      #  re-encrypt file_key with public key of user
      owner_public_key = OpenSSL::PKey::RSA.new(self.public_key)
      user_record.encrypted_file_key = Base64.encode64(owner_public_key.public_encrypt(file_key))
      save
    end
  end

  def update_share_keys(encrypted_private_key, current_password)
    Rails.logger.debug "Updating share keys..."
    share_keys.each do |share_key|
      encrypted_file_key = Base64.decode64(share_key.share_key)
      private_key = OpenSSL::PKey::RSA.new(Base64.decode64(encrypted_private_key), current_password)
      file_key = private_key.private_decrypt(encrypted_file_key)

      #  re-encrypt file_key with public key of user
      user_public_key = OpenSSL::PKey::RSA.new(self.public_key)
      share_key.share_key = Base64.encode64(user_public_key.public_encrypt(file_key))
      save
    end
  end
end
