require "openssl"

class FileSharer
    attr_reader :user_record, :owner, :recipient

    def initialize(user_record = nil, owner = nil, recipient = nil)
        @user_record = user_record
        @owner = owner
        @recipient = recipient
    end

    def process(password = nil)
        return false if user_record.nil? || owner.nil? || recipient.nil? || password.nil?
        Rails.logger.info "[FileUploader] Creating share key for user"

        if user_record.user_id == user.id
            Rails.logger.info "[FileSharer] Cannot create share key for owner"
            return false
        end
        
        # decrypt_file_key
        encrypted_file_key = Base64.decode64(user_record.encrypted_file_key)
        return false if encrypted_file_key.nil?

        private_key = OpenSSL::PKey::RSA.new(Base64.decode64(user.encrypted_private_key), password)
        file_key = private_key.private_decrypt(encrypted_file_key)

        # encrypt file key with user public key
        owner_public_key = OpenSSL::PKey::RSA.new(user.public_key)
        encrypted_file_key = Base64.encode64(owner_public_key.public_encrypt(file_key))

        # create new share key
        user_record.share_keys.create(
            user: user,
            share_key: encrypted_file_key
        )
    end
end