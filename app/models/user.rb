require "openssl"
require "base64"

class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable

  validates_presence_of   :email
  validates_format_of     :email, with: URI::MailTo::EMAIL_REGEXP
  validates_uniqueness_of :username, :email
  validates_length_of     :first_name, :middle_name, :last_name, maximum: 30, allow_nil: true
  validates_acceptance_of :tac_acceptance

  before_create :generate_identifier
  before_create :generate_user_keys
  
  # Model associations
  has_one :medical_history, dependent: :destroy
  has_one :personal_data, dependent: :destroy
  has_many :share_keys, dependent: :destroy
  has_many :user_records, dependent: :destroy

  def fullname
    "#{first_name} #{middle_name} #{last_name}"
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

  def aes256_cipher_decrypt
    cipher = OpenSSL::Cipher::AES256.new(:CBC)
    cipher.decrypt # set to decryption mode
    key = cipher.random_key
    iv = cipher.random_iv
    cipher
  end
end
