class Format
  def self.content_type(format)
    case format.to_s
    when 'jpg' then 'image/jpeg'
    when 'png' then 'image/png'
    when 'gif' then 'image/gif'
    end
  end
end
