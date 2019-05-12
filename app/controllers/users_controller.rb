class UsersController < ApplicationController
    # only authenticated users can access
    before_action :set_user, except: [:index]

    # GET /user/me
    def show
        @user_records = current_user.user_records.to_a || []
        (@user_records << current_user.records_with_access.to_a).flatten!
    end

    private
    
    def set_user
        @user = User.find(params[:id])
    end
end
