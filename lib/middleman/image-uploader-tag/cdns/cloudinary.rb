module Middleman
  module ImageUploaderTag

    class Cloudinary < Base

      def initialize(config)
      end

      def get_remote_link(image_path)
        "https://res.cloudinary.com/aliaksandrb/image/upload/t_media_lib_thumb/v1431639342/sample.jpg"
      end
    end

  end
end
