class FaceDetectionJob
  include Sidekiq::Worker

  def perform(image_id)
    image = Image.find_by(id: image_id)
    return if image.blank? || image.faces.exists?

    detector = Dlib::DNNFaceDetector.new(model_path)
    frames = image.download { |file| detector.detect(Dlib::Image.load(file.path)) }
    frames.each { |f| Face.create!(image_id: image.id, x: f.left, y: f.top, width: f.width, height: f.height) }
  end

  def model_path
    Rails.root.join('vendor', 'mmod_human_face_detector.dat').to_s
  end
end
