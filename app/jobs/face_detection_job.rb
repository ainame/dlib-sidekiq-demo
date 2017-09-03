require 'dlib'

class FaceDetectionJob
  include Sidekiq::Worker

  def perform(image_id)
    image = Image.find_by(image_id)
    return unless image

    frames = detect(image)
    save(image, frames) unless frames.empty?
  end

  def detect(image)
    detector = Dlib::DNNFaceDetector.new(model_path)
    image.fetch { |path| detector.detect(path) }
  end

  def save(image, frames)
    frames.map { |f| Face.create!(image_id: image.id, x: f.x, y: f.y, width: f.width, height: f.height) }
  end

  def model_path
    Rails.root.join('vendor', 'mmod_human_face_detector.dat').to_s
  end
end
