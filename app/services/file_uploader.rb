require 'tempfile'
require "openssl"

class FileUploader
    attr_reader :object, :owner_id, :errors

    def initialize(object = nil, owner_id = nil)
        @object = object
        @owner_id = owner_id
        @errors = []
    end

    def process
        return if object.nil? || owner_id.nil?
        Rails.logger.info "[FileUploader] Creating PHR file"
        owner = User.find(owner_id)
        file_name = "#{owner.identifier}_#{object.class.to_s.downcase}_#{DateTime.now.to_s(:number)}.phr"
        file_key, encrypted_key, encrypted_iv = encrypt_file(file_name)

        Rails.logger.info "[FileUploader] Encrypting PHR file"
        # encrypt file_key using the owner's public_key
        owner_public_key = OpenSSL::PKey::RSA.new(owner.public_key)
        encrypted_file_key = Base64.encode64(owner_public_key.public_encrypt(file_key))
        # delete file_key after encryption
        file_key = nil
        object_type = object.class.to_s.underscore
        
        if File.exist?(file_name) && encrypted_file_key.present?
            Rails.logger.info "[FileUploader] PHR file creation and encryption succeeded"

            begin
                ActiveRecord::Base.transaction do
                    # create a record model
                    owner_records = owner.user_records.create!(
                        encrypted_file_key: encrypted_file_key,
                        encrypted_cipher_key: encrypted_key,
                        encrypted_cipher_iv: encrypted_iv,
                        phr_type: object_type
                    )
                    # attach file to record model
                    file_to_attach = File.open(file_name)
                    owner_records.file.attach(
                        io: file_to_attach,
                        filename: file_name
                    )
                end
            rescue ActiveRecord::ActiveRecordError => e
                Rails.logger.error "[FileUploader] Encrypted PHR file was not saved. Error: #{e.message}"
                Rails.logger.error e.backtrace.join("\n")
                errors << "[FileUploader] Encrypted PHR file was not saved. Error: #{e.message}"
            ensure
                # delete temporary encrypted file
                File.delete(file_name)
                Rails.logger.info "[FileUploader] Temporary PHR file was deleted"
            end
        else
            errors << "[FileUploader] PHR file creation and encryption failed"
            raise "[FileUploader] PHR file creation and encryption failed"
            return errors
        end

    rescue StandardError => e
        errors << "[FileUploader] Error: #{e.message}"
        Rails.logger.error e.backtrace.join("\n")
        Rails.logger.error "[FileUploader] Error: #{e.message}"
    end

    private

    def encrypt_file(file_name)
        cipher = OpenSSL::Cipher::AES256.new(:CBC)
        cipher.encrypt # set to encryption mode
        cipher_key = cipher.random_key
        cipher_iv = cipher.random_iv

        File.open(file_name, "wb") do |outf|
            content = cipher.update(object.to_json)
            content << cipher.final
            outf.write(content)
        end

        # generate file_key, 32-byte base 64
        file_key = SecureRandom.base64(32)

        # encrypt cipher_key and cipher_iv with generated file key
        key = ActiveSupport::KeyGenerator.new(file_key).generate_key(file_key, ActiveSupport::MessageEncryptor.key_len)
        crypt = ActiveSupport::MessageEncryptor.new(key)
        encrypted_cipher_key = crypt.encrypt_and_sign(cipher_key)
        encrypted_cipher_iv = crypt.encrypt_and_sign(cipher_iv)

        [file_key, encrypted_cipher_key, encrypted_cipher_iv]
    end
end