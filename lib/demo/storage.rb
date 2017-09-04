require 'aws-sdk-s3'

module Demo
  class Storage
    attr_reader(:bucket)

    def initialize(bucket_name)
      @bucket = Aws::S3::Bucket.new(bucket_name)
    end

    # @param key [String] a key for upload file
    # @param file [File] a File object having binary data
    # @param content_type [String] content_type for the file
    def upload(key:, file:, content_type:)
      @bucket.put_object(key: key, body: file, content_type: content_type)
    end

    # @param key [String] a key to download from S3
    # @param format [String] a file extension of downloading file
    # @return [File] return a File object when caller doesn't given block
    def download(key:, format:)
      destination = Tempfile.create(["image", ".#{format}"])
      @bucket.object(key).download_file(destination.path)
      destination
    end

    def object(key)
      @bucket.object(key)
    end
  end
end
