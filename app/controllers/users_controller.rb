class UsersController < ApplicationController
    # only authenticated users can access

    # GET /user/me
    def show
        @user_records = current_user.user_records
    end
end
