class UserRecord < ApplicationRecord
    extend Enumerize

    has_one_attached :file, dependent: :destroy
    has_many :share_keys
    belongs_to :user

    validates_presence_of :encrypted_file_key, :encrypted_cipher_key, :encrypted_cipher_iv, :phr_type

    enumerize :phr_type, in: [:medical_history, :personal_data], i18n_scope: "phr_types", scope: true, predicates: true

    def read_file(user = nil, password = nil)
        return if user.nil? || password.nil?
        downloader = FileDownloader.new(self, user)
        output_file = downloader.process(password)
        return output_file
    end
end