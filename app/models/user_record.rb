class UserRecord < ApplicationRecord
    extend Enumerize

    has_one_attached :file, dependent: :destroy
    has_many :share_keys
    belongs_to :user

    validates_presence_of :encrypted_file_key, :encrypted_cipher_key, :encrypted_cipher_iv, :phr_type

    enumerize :phr_type, in: [:medical_history, :personal_data], i18n_scope: "phr_types", scope: true, predicates: true

    def read_file(user = nil, args = {})
        return if user.nil?
        password = args[:password]
        return if password.nil?
        downloader = FileDownloader.new(self, user)
        output_file = downloader.process(password)
        return output_file
    end

    def share_file(owner = nil, args = {})
        return false if owner.nil?
        password = args[:password]
        recipient = args[:recipient]
        return false if password.nil? || recipient.nil?
        sharer = FileSharer.new(self, owner, recipient)
        status = sharer.process(password)
        return status
    end
end