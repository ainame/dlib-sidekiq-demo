class Image < ApplicationRecord
  enum format: [:jpg, :png, :gif]

  def fetch(&completion)
    download do |path|
      completion.call(path)
    end
  end

  def download(&block)
    Tempfile.create('image', format.to_s) do |file|
      block.call(file.path)
    end
  end
end
