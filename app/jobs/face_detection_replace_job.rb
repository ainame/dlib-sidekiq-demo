class FaceDetectionReplaceJob
  include Sidekiq::Worker

  def perform(image_id)
    image = Image.find_by(id: image_id)
    return if image.blank? || image.faces.exists?

    detector = Dlib::DNNFaceDetector.new(model_path)
    image.download do |file|
      buffer = Dlib::Image.load(file.path)
      frames = detector.detect(buffer)
      frames.each do |f|
        Face.create!(image_id: image.id, x: f.left, y: f.top, width: f.width, height: f.height)
        buffer.draw_rectangle!(f, [255, 0, 0], 3)
      end

      unless frames.empty?
        Tempfile.create(['buffer', image.format.to_s]) do |temp|
          buffer.save_jpeg(temp.path)
          image.replace!(temp)
        end
      end
    end
  end

  def model_path
    Rails.root.join('vendor', 'mmod_human_face_detector.dat').to_s
  end
end
