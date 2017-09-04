require 'demo/storage'

class Image < ApplicationRecord
  has_many(:faces)
  enum(format: [:jpg, :png, :gif])

  def self.upload!(file)
    extname = File.extname(file).downcase
    path = "#{SecureRandom.uuid}#{extname}"
    format = extname.sub('.', '')
    storage.upload(key: path, file: file, content_type: Format.content_type(format))
    Image.create!(path: path, format: format)
  end

  def download(&block)
    file = storage.download(key: path, format: format)
    block.call(file)
  ensure
    file.close if file
  end

  def url
    storage.object(path).presigned_url(:get, expires_in: 3600)
  end

  private

  def self.storage
    @storage ||= ::Demo::Storage.new(Rails.application.secrets.s3_bucket)
  end

  def storage
    self.class.storage
  end
end
