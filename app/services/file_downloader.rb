require 'tempfile'
require "openssl"

class FileDownloader
    attr_reader :user_record, :user_id, :errors

    def initialize(user_record = nil, user_id = nil)
        @user_record = user_record
        @user_id = user_id
        @errors = []
    end

    def process(password)
        return if user_record.nil? || user_id.nil?
        
        # if owner of user record is the one downloading the file,
        # then use encrypted_file_key of user record
        # else, use share key of user for that user record
        encrypted_file_key = if user_record.owner_id == user_id
            user_record.encrypted_file_key
        else
            user_record.share_keys.find_by(user_id: user_id)
        end
        return if encrypted_file_key.nil?

        decrypted_data = decrypt_file(password)

        # TODO: resolve to an object
        # read type based on file
        # type = 
        # @object = {type.constantize}.new()

        # TODO: should return a PDF file
        # Create service to transform serialized hash to PDF
        # PdfGenerator.new(object)
        # return PDF file
    rescue => e
        Rails.logger.info "[FileDownloader] Error: #{e.message}"
    end

    private

    def transform
        # object = 
    end

    def decrypt_file(password)
        # decrypt private key with password
        private_key = OpenSSL::PKey::RSA.new(user.encrypted_private_key, password)
        file_key = private_key.private_decrypt(encrypted_file_key)

        # decrypt cipher_key and cipher_iv with decrypted file key
        key = ActiveSupport::KeyGenerator.new(file_key).generate_key(file_key, ActiveSupport::MessageEncryptor.key_len)
        crypt = ActiveSupport::MessageEncryptor.new(key)

        # create cipher that will be used to decrypt the file
        cipher = OpenSSL::Cipher::AES256.new(:CBC)
        cipher.decrypt # set to decryption mode
        # decrypt key and iv
        cipher.key = crypt.decrypt_and_verify(user_record.encrypted_cipher_key)
        cipher.iv = crypt.decrypt_and_verify(user_record.encrypted_cipher_iv)

        # download file
        encrypted_file = user_record.file.download_blob_to_tempfile()
        encrypted_data = encrypted_file.read
        encrypted_file.close

        decrypted_data = cipher.update(encrypted_data)
        decrypted_data << cipher.final
    rescue => e
        Rails.logger.error "[FileDownloader] Error encountered while decrypting. #{e.message}"
        errors << "[FileDownloader] Error encountered while decrypting. #{e.message}"
    ensure
        encrypted_file.close! if encrypted_file.present?
    end

end