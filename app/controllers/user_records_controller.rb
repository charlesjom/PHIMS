class UserRecordsController < ApplicationController
    def index
        @user_records = current_user.user_records
    end

    def show
        @user_record = UserRecord.where(id: params[:id]).includes(:user).first
    end

    def view
        user_record = UserRecord.find(params[:id])
        @output = user_record.read_file(current_user, user_record_params[:password])
    end
    
    private
    
    def user_record_params
        params.require(:user_record).permit(:password)
    end
end