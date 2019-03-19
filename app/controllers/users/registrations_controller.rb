class Users::RegistrationsController < Devise::RegistrationsController
	def create
		super
	end

	def update
		super
	end

	protected

	def after_sign_up_path_for(resource)
		
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
		params.require(:user).permit(:first_name, :middle_name, :last_name, :username, :email, :password, :password_confirmation)
	end

	def account_update_params
		params.require(:user).permit(:first_name, :middle_name, :last_name, :username, :email, :password, :password_confirmation)
	end
end