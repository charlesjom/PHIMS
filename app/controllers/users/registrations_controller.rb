require "openssl"
require "base64"

class Users::RegistrationsController < Devise::RegistrationsController
	def create
		keypair = OpenSSL::PKey::RSA.new(4096)
		# private key is encrypted with password using AES-256
		encrypted_pri_key = keypair.to_pem(aes256_cipher_encrypt, params[:user][:password])
		pub_key = keypair.public_key.to_pem

		params[:user][:encrypted_pri_key] = encrypted_pri_key
		params[:user][:pub_key] = pub_key

		super
	end

	def update
		# the private key is retrieved using the current password
		encrypted_pri_key = User.find_by(email: params[:user][:email])[:encrypted_pri_key]
		keypair = OpenSSL::PKey::RSA.new(encrypted_pri_key, params[:user][:current_password])
		# private key is encrypted again with the new password using AES-256
		new_encrypted_pri_key = keypair.to_pem(aes256_cipher_encrypt, params[:user][:password])

		params[:user][:encrypted_pri_key] = new_encrypted_pri_key

		super
	end

	private
		def aes256_cipher_encrypt
		cipher = OpenSSL::Cipher::AES256.new(:CBC)
		cipher.encrypt # encryption mode
		key = cipher.random_key
		iv = cipher.random_iv
		return cipher
	end

	def aes256_cipher_decrypt
		cipher = OpenSSL::Cipher::AES256.new(:CBC)
		cipher.decrypt # decryption mode
		key = cipher.random_key
		iv = cipher.random_iv
		return cipher
	end

	def sign_up_params
		params.require(:user).permit(:first_name, :middle_name, :last_name, :username, :email, :password, :password_confirmation, :encrypted_pri_key, :pub_key)
	end

	def account_update_params
		params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation, :current_password, :encrypted_pri_key)
	end
end