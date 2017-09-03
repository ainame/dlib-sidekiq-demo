class Image < ApplicationRecord
  enum format: [:jpg, :png, :gif]

  def self.content_type(format)
    case format.to_s
    when 'jpg' then 'image/jpeg'
    when 'png' then 'image/png'
    when 'gif' then 'image/gif'
    end
  end

  def self.upload!(file)
    extname = File.extname(file).downcase
    path = "#{SecureRandom.uuid}#{extname}"
    format = extname.sub('.', '')
    storage.upload(key: path, content_type: content_type(format))
    Image.create!(path: path, format: format)
  end

  def download(&block)
    file = storage.download(key)
    block.call(file)
  ensure
    file.close
  end

  private

  def storage
    @storage ||= Demo::Storage.new(Rails.application.secrets.s3_bucket)
  end
end
