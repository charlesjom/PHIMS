require 'tempfile'
require "openssl"

class FileDownloader
    attr_reader :user_record, :errors, :user
    
    def initialize(user_record = nil, user = nil)
        @user_record = user_record
        @user = user
        @errors = []
    end

    def process(password = nil, readonly = true)
        return if user_record.nil? || user.nil? || password.nil?
        
        # if owner of user record is the one downloading the file,
        # then use encrypted_file_key of user record
        # else, use share key of user for that user record
        encrypted_file_key = if user_record.user_id == user.id
            Base64.decode64(user_record.encrypted_file_key)
        else
            Base64.decode64(user_record.share_keys.find_by(user_id: user.id).share_key)
        end
        return if encrypted_file_key.nil?

        decrypted_data = decrypt_file(password, encrypted_file_key)

        type = user_record.phr_type
        object = type.classify.constantize.new

        if (user_record.user_id == user.id) && (!readonly)
            resolved_object = resolve_object(object, decrypted_data)
            return resolved_object
        else
            # read type based on file
            object.from_json(decrypted_data)
        end

        # TODO: should return a PDF file
        # Create service to transform serialized hash to PDF
        pdf_generator = PdfGenerator.new(object, user_record)
        pdf_generator.process   # return PDF file
    rescue => e
        errors << "[FileDownloader] Error: #{e.message}"
        Rails.logger.error "[FileDownloader] Error: #{e.message}"
        Rails.logger.error e.backtrace.join("\n")
    end

    private

    def decrypt_file(password, encrypted_file_key)
        Rails.logger.info "[FileDownloader] Decrypting file"
        # decrypt private key with password
        private_key = OpenSSL::PKey::RSA.new(Base64.decode64(user.encrypted_private_key), password)
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
        encrypted_data = user_record.file.download

        decrypted_data = cipher.update(encrypted_data)
        decrypted_data << cipher.final
    rescue => e
        Rails.logger.error "[FileDownloader] Error encountered while decrypting file. Error: #{e.message}"
        Rails.logger.error e.backtrace.join("\n")
        errors << "[FileDownloader] Error encountered while decrypting file. Error: #{e.message}"
    end

    def resolve_object(object, json)
        
    end

end