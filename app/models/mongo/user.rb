require "openssl"
require "base64"

class Mongo::User
	include Mongoid::Document
	# Include default devise modules. Others available are:
	# :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
	devise :database_authenticatable, :registerable,
			:recoverable, :rememberable, :validatable

	## Database authenticatable
	field :email,              type: String, default: ""
	field :encrypted_password, type: String, default: ""

	## Recoverable
	field :reset_password_token,   type: String
	field :reset_password_sent_at, type: Time

	## Rememberable
	field :remember_created_at, type: Time

	## Trackable
	# field :sign_in_count,      type: Integer, default: 0
	# field :current_sign_in_at, type: Time
	# field :last_sign_in_at,    type: Time
	# field :current_sign_in_ip, type: String
	# field :last_sign_in_ip,    type: String

	## Confirmable
	# field :confirmation_token,   type: String
	# field :confirmed_at,         type: Time
	# field :confirmation_sent_at, type: Time
	# field :unconfirmed_email,    type: String # Only if using reconfirmable

	## Lockable
	# field :failed_attempts, type: Integer, default: 0 # Only if lock strategy is :failed_attempts
	# field :unlock_token,    type: String # Only if unlock strategy is :email or :both
	# field :locked_at,       type: Time
	# Include default devise modules. Others available are:
	# :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
	devise :database_authenticatable, :registerable,
			:recoverable, :rememberable, :validatable

	## Database authenticatable
	field :email, type: String, default: ""
	field :encrypted_password, type: String, default: ""
	
	## Recoverable
	field :reset_password_token,   type: String
	field :reset_password_sent_at, type: Time

	## Rememberable
	field :remember_created_at, type: Time

	## User Details
	field :username, type: String
	field :_id, type: String, default: ->{ email.to_s.downcase }, overwrite: true

	field :first_name, type: String
	field :middle_name, type: String
	field :last_name, type: String

	## User keypair
	field :encrypted_private_key, type: String
	field :public_key, type: String

	attr_accessor :tac_acceptance

	# Association with other models
	# TODO: need to fix the association with medical_history and personal_data
	has_one :medical_history, dependent: :destroy
	has_one :personal_data, dependent: :destroy
	has_many :share_keys
	# TODO: might need to remove this association
	## Records
	has_many :records

	## Before validation methods
	before_validation(on: :create) do
		self.email = email.downcase
		self.id = email
	end

	## Validators
	validates_presence_of :email, :pub_key, :encrypted_pri_key
	validates_presence_of :first_name, :middle_name, :last_name, :username
	validates_format_of :first_name, :middle_name, :last_name, with: /\A[\w ]+\z/i
	validates_format_of :email, with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
	validates_uniqueness_of :email, :case_sensitive => false

	# Methods
	after_create :create_keypair
	after_update :update_keypair

	private
	# TODO: move to service

	def create_keypair
	  keypair = OpenSSL::PKey::RSA.new(4096)
		# private key is encrypted with password using AES-256
		# password will be an attr_accessor
		self.encrypted_pri_key = keypair.export(aes256_cipher_encrypt, self.password)
		self.pub_key = keypair.public_key
	end

	# def update_keypair
	#   keypair = OpenSSL::PKey::RSA.new(self.encrypted_pri_key, self.password)
	# end

	def aes256_cipher_encrypt
		cipher = OpenSSL::Cipher::AES256.new(:CBC)
		cipher.encrypt # set to encryption mode
		key = cipher.random_key
		iv = cipher.random_iv
		cipher
	end

	def aes256_cipher_decrypt
		cipher = OpenSSL::Cipher::AES256.new(:CBC)
		cipher.decrypt # set to decryption mode
		key = cipher.random_key
		iv = cipher.random_iv
		cipher
	end
end
