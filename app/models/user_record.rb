class UserRecord < ApplicationRecord
    extend Enumerize

    has_one_attached :file, dependent: :destroy
    has_many :share_keys, dependent: :destroy
    belongs_to :user

    validates_presence_of :encrypted_file_key, :encrypted_cipher_key, :encrypted_cipher_iv, :phr_type

    enumerize :phr_type, in: [:medical_history, :personal_data], i18n_scope: "phr_types", scope: true, predicates: true

    def read_file(user = nil, args = {})
        password = args[:password]
        downloader = FileDownloader.new(self, user)
        output = downloader.process(password)
        if downloader.errors.any?
            downloader.errors.each do |error|
                errors.add(:base, error)
            end
        end
        return output
    end

    def share_file(owner = nil, args = {})
        password = args[:password]
        share_recipient = args[:share_recipient]
        sharer = FileSharer.new(self, owner, share_recipient)
        status = sharer.process(password)
        if sharer.errors.any?
            sharer.errors.each do |error|
                errors.add(:base, error)
            end
        end
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