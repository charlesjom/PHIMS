class UserRecordsController < ApplicationController
    def index
        @user_records = current_user.user_records
    end

    def show
        @user_record = UserRecord.find(params[:id]).read_file(current_user.id)
    end
end