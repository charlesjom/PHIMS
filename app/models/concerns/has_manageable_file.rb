module HasManageableFile
    extend ActiveSupport::Concern
    extend ActiveModel::Callbacks

    included do
        define_model_callbacks :save, only: [:after]
        after_save :store_file
    end

    def store_file
        uploader = FileUploader.new(self, self.owner_id)
        uploader.process
        return
    end

    def read_file
        # TODO: get file_key and object_key
        # current_user.user_records.where()
        # downloader = FileDownloader.new(object_key, file_key)
        
        # output_file = downloader.process
        return
    end
end