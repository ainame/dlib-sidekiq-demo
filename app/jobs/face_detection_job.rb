require 'dlib'

class FaceDetectionJob
  include Sidekiq::Worker

  sidekiq_options(queue: :default)

  def perform(image_id)
    image = Image.find_by(id: image_id)
    return unless image
    return if image.faces.exists?

    frames = detect(image)
    save(image, frames) unless frames.empty?
  end

  def detect(image)
    detector = Dlib::DNNFaceDetector.new(model_path)
    image.download { |file| detector.detect(Dlib::Image.load(file.path)) }
  end

  def save(image, frames)
    frames.map { |f| Face.create!(image_id: image.id, x: f.left, y: f.top, width: f.width, height: f.height) }
  end

  def model_path
    Rails.root.join('vendor', 'mmod_human_face_detector.dat').to_s
  end
end
