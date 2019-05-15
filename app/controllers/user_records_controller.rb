class UserRecordsController < ApplicationController
    before_action :set_user_record, only: [:show, :view, :destroy, :edit, :share, :share_form, :edit_data]

    def index
        @user_records = current_user.user_records.to_a || []
        (@user_records << current_user.records_with_access.to_a).flatten!
    end

    def show
        if @user_record.is_owner?(current_user)
            @share_keys = @user_record.share_keys
        end
    end

    def view
        output = @user_record.read_file(current_user, user_record_params)
        if @user_record.errors.empty?
            send_data(output.force_encoding('BINARY'), type: 'application/pdf', disposition: 'inline')
        else
            redirect_to user_record_path(@user_record), error: @user_record.errors.full_messages.join(". ")
        end
    end

    def destroy
        @user_record.destroy
        redirect_to root_path
    end

    def share_form
    end

    def share
        status = @user_record.share_file(current_user, share_user_record_params)
    end

    def edit
    end

    def edit_data
        @output = @user_record.read_file(current_user, user_record_params)
    end
    
    private

    def set_user_record
        user_record = UserRecord.find(params[:id])
        if user_record.has_access?(current_user)
            @user_record = UserRecord.find(params[:id])
        else
            redirect_to root_path, warning: 'You do not have permission to access that record'
        end
    end
    
    def user_record_params
        params.require(:user_record).permit(:password)
    end

    def share_user_record_params
        params.require(:user_record).permit(:password, :share_recipient)
    end
end