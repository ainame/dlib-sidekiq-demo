class Frame < Struct.new(:x, :y, :width, :height)
end

class Face < ApplicationRecord
  def frame
    frame = Frame.new(x, y, width, height).freeze
    frame
  end
end
