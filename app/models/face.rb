class Face < ApplicationRecord
  belongs_to(:image)

  def frame
    frame = Frame.new(x, y, width, height).freeze
    frame
  end

  class Frame < Struct.new(:x, :y, :width, :height); end
end
