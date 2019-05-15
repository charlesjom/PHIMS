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

  def update_user_keys(current_password = nil, new_password = nil)
    if current_password.nil?
      # create new keypair, since old user keys cannot be retrieved anymore
      keypair = OpenSSL::PKey::RSA.new(4096)

      cipher = OpenSSL::Cipher::AES256.new(:CBC)
      cipher.encrypt # set to encryption mode
      key = cipher.random_key
      iv = cipher.random_iv

      self.encrypted_private_key = Base64.encode64(keypair.export(cipher, current_password))
      self.public_key = keypair.public_key

      # delete all owned user_records and share keys for this user
      user_records.delete_all
    else
      # decrypt private key using current password
      keypair = OpenSSL::PKey::RSA.new(Base64.decode64(self.encrypted_private_key), current_password)
      cipher = OpenSSL::Cipher::AES256.new(:CBC)
      cipher.encrypt # set to encryption mode
      key = cipher.random_key
      iv = cipher.random_iv
      # re-encrypt private key with new password
      self.encrypted_private_key = Base64.encode64(keypair.export(cipher, new_password))
    end
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

  def generate_new_user_keys
    generate_user_keys
    # delete all user records and share keys since it can't be decrypted anymore
    user_records.delete_all
    share_keys.delete_all
  end
end
