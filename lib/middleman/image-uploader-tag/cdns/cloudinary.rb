require 'cloudinary'
require 'cloudinary/uploader'
require 'cloudinary/utils'

module Middleman
  module ImageUploaderTag

    class CloudinaryCDN < BaseCDN

      def initialize(config)
        Cloudinary.config do |config|
          config.cloud_name = config[:cloud_name]
          config.api_key = config[:api_key]
          config.api_secret = config[:api_secret]
          config.enhance_image_tag = config[:enhance_image_tag] || false,
          config.static_image_support = config[:static_image_support] || false,
          config.secure = config[:secure] || false
        end
      end

      def get_remote_link(image_path)
        #"https://res.cloudinary.com/aliaksandrb/image/upload/t_media_lib_thumb/v1431639342/sample.jpg"
        upload_to_cloud(image_path)[:secure_url]
      end

      def upload_to_cloud(file, options = {})
        Cloudinary::Uploader.upload(file, options = {}).inject({}) do |memo, (k,v)|
          memo[k.to_sym] = v
          memo
        end
      end
    end

  end
end
