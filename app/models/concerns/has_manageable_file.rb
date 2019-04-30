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
end