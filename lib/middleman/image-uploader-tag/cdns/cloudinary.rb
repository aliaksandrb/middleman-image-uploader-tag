require 'cloudinary'

module Middleman
  module ImageUploaderTag

    class CloudinaryCDN < BaseCDN

      def initialize(config)
        #check for requried keys
        Cloudinary.config do |c|
          config.each { |key, value| c.public_send("#{key}=", value) }
        end
      end

      def get_remote_link(image_path)
        upload_to_cloud(image_path)[:secure_url]
      end

      def upload_to_cloud(file, options = {})
        options.merge!({ use_filename: true, unique_filename: false })

        Cloudinary::Uploader.upload(file, options).inject({}) do |memo, (k,v)|
          memo[k.to_sym] = v
          memo
        end
      end
    end

  end
end
