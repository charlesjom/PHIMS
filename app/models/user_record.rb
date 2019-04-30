class UserRecord < ApplicationRecord
    has_one_attached :file, dependent: :destroy
    has_many :share_keys

    validates_presence_of :encrypted_file_key, :encrypted_cipher_key, :encrypted_cipher_iv, :phr_type

    def read_file(user_id = nil)
        return if user_id.nil?
        downloader = FileDownloader.new(self, user_id)
        output_file = downloader.process
        return
    end
end