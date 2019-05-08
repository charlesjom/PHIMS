class UserRecordsController < ApplicationController
    before_action :set_user_record, only: [:show, :view, :destroy, :share, :share_form]

    def index
        @user_records = current_user.user_records
    end

    def view
        output = @user_record.read_file(current_user, read_user_record_params)
        send_file(output, type: 'application/pdf', disposition: 'inline')
    end

    def destroy
        @user_record.destroy
    end

    def share_form
    end

    def share
        status = @user_record.share_file(current_user, share_user_record_params)
    end
    
    private

    def set_user_record
        @user_record = UserRecord.find(params[:id])
    end
    
    def read_user_record_params
        params.require(:user_record).permit(:password)
    end

    def share_user_record_params
        params.require(:user_record).permit(:password, :share_recipient)
    end
end