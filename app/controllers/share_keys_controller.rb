class ShareKeysController < ApplicationController
    def destroy
        user_record = UserRecord.find(params[:user_record_id])
        @share_key = user_record.share_keys.find(params[:id])
        status = @share_key.destroy
        if status
            redirect_to user_record_path(user_record), success: "Successfully deleted share key for #{@share_key.user.email}."
        else
            redirect_to user_record_path(user_record), error: "Failed to delete share key for #{@share_key.user.email}."
        end
    end
end
