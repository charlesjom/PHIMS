require "openssl"

class FileSharer
    attr_reader :user_record, :owner, :recipient_email

    def initialize(user_record = nil, owner = nil, recipient_email = nil)
        @user_record = user_record
        @owner = owner
        @recipient_email = recipient_email
    end

    def process(password = nil)
        return false if user_record.nil? || owner.nil? || recipient_email.nil? || password.nil?
        Rails.logger.info "[FileSharer] Creating share key for user"

        recipient = User.find_by(email: recipient_email)

        if owner == recipient
            Rails.logger.info "[FileSharer] Cannot create share key for owner"
            return false
        end
        
        # decrypt_file_key
        encrypted_file_key = Base64.decode64(user_record.encrypted_file_key)
        return false if encrypted_file_key.nil?

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
    end
end