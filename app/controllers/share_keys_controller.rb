class ShareKeysController < ApplicationController
    def destroy
        user_record = UserRecord.find(params[:user_record_id])
        @share_key = user_record.share_keys.find(params[:id])
        @share_key.destroy
    end
end
