class UsersController < ApplicationController
    
    # GET /users/
    def new
        # if current_user.nil?
        @user = User.new 
        # else
            # redirect_to root_path
        # end
    end

    # POST /users
    def create
        user = User.new user_params
        if user.save
            render json: user, status: created
        else
            render json: {message: user.errors.full_messages.first}, status: 422
        end
    end

    private
        def user_params
            params.require(:user).permit(:username, :email, :first_name, :middle_name, :last_name, :password, :password_confirmation)
        end
end
