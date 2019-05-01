class UserRecord < ApplicationRecord
    has_one_attached :file, dependent: :destroy
    has_many :share_keys
    belongs_to :user

    validates_presence_of :encrypted_file_key, :encrypted_cipher_key, :encrypted_cipher_iv, :phr_type

    before_destroy :remove_files

    def read_file(user, password = nil)
        return if user.nil? || password.nil?
        downloader = FileDownloader.new(self, user)
        output_file = downloader.process(password)
        return output_file
    end

    private

    def remove_files
        file.purge
    end
end