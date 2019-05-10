class UsersController < ApplicationController
    # only authenticated users can access

    # GET /user/me
    def show
        @user_records = current_user.user_records.to_a || []
        (@user_records << current_user.records_with_access.to_a).flatten!
    end
end
