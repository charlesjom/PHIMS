class UserRecordsController < ApplicationController
    before_action :set_user_record, only: [:show, :view, :destroy]

    def index
        @user_records = current_user.user_records
    end

    def show
    end

    def view
        @output = @user_record.read_file(current_user, user_record_params[:password])
    end

    def destroy
        @user_record.destroy
    end
    
    private

    def set_user_record
        @user_record = UserRecord.find(params[:id])
    end
    
    def user_record_params
        params.require(:user_record).permit(:password)
    end
end