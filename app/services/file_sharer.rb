require "openssl"

class FileSharer
    attr_reader :user_record, :owner, :recipient_email, :errors

    def initialize(user_record = nil, owner = nil, recipient_email = nil)
        @user_record = user_record
        @owner = owner
        @recipient_email = recipient_email
        @errors = []
    end

    def process(password = nil)
        if user_record.blank? || owner.blank? || recipient_email.blank?
            message = "can't be blank"
            add_error(:user_record, message) if user_record.blank?
            add_error(:owner, message) if owner.blank?
            add_error(:recipient_email, message) if recipient_email.blank?
        end
        Rails.logger.debug "[FileSharer] Creating share key for user"

        if !(owner.valid_password?(password))
            add_error(:password)
        end

        recipient = User.find_by(email: recipient_email)

        if recipient.nil?
            Rails.logger.debug "[FileSharer] Recipient does not exist"
            add_error(:recipient, "does not exist")
        end

        if owner == recipient
            Rails.logger.debug "[FileSharer] Cannot create share key for owner"
            add_error(:recipient, "is the same as the owner")
        end

        if ShareKey.exists?(user: recipient, user_record: user_record)
            Rails.logger.debug "[FileSharer] Cannot create share key for user with share key already"
            add_error(:recipient, "already has a share key")
        end

        return false if errors.any?
        
        # decrypt_file_key
        encrypted_file_key = Base64.decode64(user_record.encrypted_file_key)
        return false if encrypted_file_key.blank?

        private_key = OpenSSL::PKey::RSA.new(Base64.decode64(owner.encrypted_private_key), password)
        file_key = private_key.private_decrypt(encrypted_file_key)

        # encrypt file key with recipient's public key
        recipient_public_key = OpenSSL::PKey::RSA.new(recipient.public_key)
        encrypted_file_key = Base64.encode64(recipient_public_key.public_encrypt(file_key))
        file_key = nil

        # create new share key
        user_record.share_keys.create(
            user: recipient,
            share_key: encrypted_file_key
        )
    rescue => e
        raise e
    end

    private

    def add_error(attribute, message = "is invalid")
        errors << "#{attribute.to_s.humanize} #{message}"
    end
end