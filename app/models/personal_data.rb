require 'aws-sdk'
require "openssl"
require "securerandom"

class PersonalData
    extend ActiveModel::Naming
    include ActiveModel::Model
    include ActiveModel::Serializers::JSON

    # def initialize
    #     @errors = ActiveModel::Errors.new(self)
    # end

    attr_accessor :patient_demographics, :emergency_contacts, :insurances
    attr_reader :errors

    ## Associations with other models
    ## TODO: need to fix association with user
    # belongs_to :user, foreign_key: "owner"
    
    # def validate!
    # end

    def patient_demographics_attributes=(attributes)
        @patient_demographics = PatientDemographics.new(patient_demographics_params)
    end

    def emergency_contacts_attributes=(attributes)
        @emergency_contacts ||= []
        attributes.each do |i, emergency_contact_params|
            @emergency_contacts.push(EmergencyContact.new(emergency_contact_params))
        end
    end

    def insurances_attributes=(attributes)
        @insurances ||= []
        attributes.each do |i, insurances|
            @insurances.push(Insurance.new(insurance_params))
        end
    end

    def attributes=(hash)
        hash.each do |key, value|
            send("#{key}=", value)
        end
    end
    
    def attributes
        instance_values
    end

    # Method for handling error messages
    def read_attribute_for_validation(attr)
        send(attr)
    end

    def self.human_attribute_name(attr, options = {})
        attr
    end

    def self.lookup_ancestors
        [self]
    end

    ## Methods
    def create_file
        # TODOS
        # 1. method for writing to JSON file
        personal_data_in_json = self.to_json
        file_name = self.owner.to_s + "_personal_data.json"
        f = File.new(file_name, 'w')

        # 2. encrypt file
        # generate file_key, 32-byte base 64
        file_key = SecureRandom.base64(32)
        
        # encrypt file using file_key
        buffer = ""
        File.open("#{file_name}.enc", "wb") do |outf|
            File.open("#{file_name}", "rb") do |inf|
                while inf.read(4096, buffer)
                    outf << aes256_cipher_encrypt.update(buffer)
                end
                outf << aes256_cipher_encrypt.final
            end
        end

        # get owner_public_key
        owner_pub_key = self.owner.pub_key
        # encrypt file_key using owner_public_key
        encrypted_file_key = file_key.to_pem(aes256_cipher_encrypt, owner_pub_key)
        encrypted_file_name = file_name + ".enc"

        # 3. upload encrypted file to storage
        s3 = Aws::S3::Resource.new(region: ENV['AWS_REGION'])
        obj = s3.bucket('phims-uplb').object(encrypted_file_name)
        obj.upload_file("#{self.owner.to_s}/#{encrypted_file_name}")

        # 4. create a record model
        if (storage_url != nil) and (encrypted_file_key != nil)
            # create record model
            @record = Record.create(
                encrypted_file_key: encrypted_file_key,
                storage_url: storage_url
            )
            return true # if upload succeeded
        else
            return false # if upload failed
        end
    end


    def read_file
        # get encrypted_filename
        buf = ""
        File.open("#{file_name}.enc", "wb") do |outf|
            File.open("#{file_name}", "rb") do |inf|
                while inf.read(4096, buf)
                    outf << aes256_cipher_decrypt.update(buf)
                end
                outf << aes256_cipher_decrypt.final
        end
    end
    
    private
        def aes256_cipher_encrypt
            cipher = OpenSSL::Cipher::AES256.new(:CBC)
            cipher.encrypt # encryption mode
            key = cipher.random_key
            iv = cipher.random_iv
            return cipher
        end

        def aes256_cipher_decrypt
            cipher = OpenSSL::Cipher::AES256.new(:CBC)
            cipher.decrypt # decryption mode
            key = cipher.random_key
            iv = cipher.random_iv
            return cipher
        end
    end
end