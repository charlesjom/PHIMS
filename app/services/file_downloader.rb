require 'tempfile'
require "openssl"

class FileDownloader
    attr_reader :user_record, :errors, :user, :access_log
    
    def initialize(user_record = nil, user = nil)
        @user_record = user_record
        @user = user
        @errors = []
        @access_log = nil
    end

    def process(password = nil, readonly = true)
        if user_record.blank? || user.blank?
            message = "can't be blank"
            add_error(:user_record, message) if user_record.blank?
            add_error(:owner, message) if owner.blank?
        end
        Rails.logger.debug "[FileDownloader] Downloading file for user"
        # if owner of user record is the one downloading the file,
        # then use encrypted_file_key of user record
        # else, use share key of user for that user record
        encrypted_file_key = if user_record.user_id == user.id
            Base64.decode64(user_record.encrypted_file_key)
        else
            user_share_key = user_record.share_keys.find_by(user_id: user.id)
            @access_log = user_record.access_logs.create(user_id: user.id, share_key_id: user_share_key.id)
            Base64.decode64(user_share_key.share_key)
        end

        return if encrypted_file_key.nil?

        if !(user.valid_password?(password))
            add_error(:password)
            return false
        end

        decrypted_data = decrypt_file(password, encrypted_file_key)

        type = user_record.phr_type
        object_class = type.classify.constantize
        object = object_class.new

        if (user_record.user_id == user.id) && (!readonly)
            resolved_object = resolve_object(object_class, object, decrypted_data)
            return resolved_object
        else
            # read type based on file
            object.from_json(decrypted_data)
        end

        # transform object to PDF
        pdf_generator = PdfGenerator.new(object, user_record, access_log.id)
        pdf_generator.process   # return PDF file
    rescue => e
        errors << "[FileDownloader] Error: #{e.message}"
        Rails.logger.error "[FileDownloader] Error: #{e.message}"
        Rails.logger.error e.backtrace.join("\n")
        return
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
        raise e
    end

    private

    def resolve_object(object_class, object, json)
        Rails.logger.debug "[FileDownloader] Resolving object"
        object.from_json(json)
        params = {}
        object.attributes.each do |name, values|
            next if name == 'owner_id' || name == 'record_id'
            type = name.classify.constantize
            resolved_name = name + "_attributes"
            if type.to_s == "PersonalDemographics"
                values.each do |k, v|
                    next if type::ATTRIBUTES.include? k.to_sym
                    values.delete(k)
                end
            else
                values.each do |value, out|
                    # delete unnecessary fields per attribute
                    value.each do |k, v|
                        next if type::ATTRIBUTES.include? k.to_sym
                        value.delete(k)
                    end
                    attributes << value
                end
            end
            params[resolved_name.to_sym] = type.to_s == "PersonalDemographics" ? values : attributes
        end
        
        resolved_object = object_class.new(params)
        return resolved_object
    end

    def add_error(attribute, error = "is invalid")
        message = "#{attribute.to_s.humanize} #{error}"
        AccessLog.find(access_log.id).update(message: message) if access_log.present?
        errors << message
    end

end