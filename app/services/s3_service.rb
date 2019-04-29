class S3Service
    attr_reader :s3, :s3_bucket

    def initialize(opts = {})
        @s3 = Aws::S3::Client.new(
            access_key_id: ENV['AWS_ACCESS_KEY_ID']
            secret_access_key: ENV['AWS_SECRET_ACCESS_KEY_']
            region: ENV['AWS_REGION']
        )
        @s3_bucket = fetch_bucket
    end

    def write_file(file)
        filename = File.basename(file)
        s3_obj = s3_bucket.object(filename)
        s3_obj.upload_file(file)
    end

    def url_for(key)
        s3_bucket.object(key).public_url.to_s
    end

    def download_file
        s3_obj = s3_bucket.object(filename)
        # s3_obj.get(response_target: )
        # TODO: complete this
    end

    def exists?(key)
        return false unless Rails.env.production?
        s3_bucket.object(key).exists?
    rescue Aws::Errors::ServiceError => e
        Rails.logger.error "[AWS-SDK ERROR] Error encountered while checking existence of #{key}: #{e.message}"
        false
    end
    

    def delete_file(key)
        return if key.blank? || !exists?(key)
        s3_bucket.object(key).delete
    end

    private

    def fetch_bucket
        bucket = ENV['S3_BUCKET_NAME']
        s3_resource = Aws::S3::Resource.new client: s3
        s3_resource.bucket(bucket)
    end

end