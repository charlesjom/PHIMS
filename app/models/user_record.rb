class UserRecord < ApplicationRecord
    extend Enumerize

    has_one_attached :file, dependent: :destroy
    has_many :share_keys, dependent: :destroy
    belongs_to :user

    validates_presence_of :encrypted_file_key, :encrypted_cipher_key, :encrypted_cipher_iv, :phr_type

    enumerize :phr_type, in: [:medical_history, :personal_data], i18n_scope: "phr_types", scope: true, predicates: true

    def read_file(user = nil, args = {})
        return if user.nil?
        password = args[:password]
        return if password.nil?
        downloader = FileDownloader.new(self, user)
        output = downloader.process(password)
        errors.add(:base, 'Error encountered while decrypting record') if downloader.errors.any?
        return output
    end

    def share_file(owner = nil, args = {})
        return false if owner.nil?
        password = args[:password]
        share_recipient = args[:share_recipient]
        return false if password.nil? || share_recipient.nil?
        sharer = FileSharer.new(self, owner, share_recipient)
        status = sharer.process(password)
        return status
    end
    
    def is_owner?(user = nil)
        return false if user.nil?
        self.user == User.find(user.id)
    end

    def has_access?(user = nil)
        return false if user.nil?
        self.share_keys.exists?(user: user) || is_owner?(user)
    end
end