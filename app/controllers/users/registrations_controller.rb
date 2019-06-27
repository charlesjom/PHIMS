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

	def sign_up_params
		params.require(:user).permit(:first_name, :middle_name, :last_name, :username, :email, :password, :password_confirmation)
	end

	def account_update_params
		params.require(:user).permit(:first_name, :middle_name, :last_name, :username, :email, :password, :password_confirmation, :current_password)
	end
end