require 'cloudinary'

module Middleman
  module ImageUploaderTag

    class CloudinaryCDN < BaseCDN
      OBLIGATORY_OPTIONS = [:cloud_name, :api_secret, :api_key]

      def initialize(config)
        raise AuthorizationRequired if OBLIGATORY_OPTIONS.any? { |k| config[k].nil? }

        Cloudinary.config do |c|
          config.each { |key, value| c.public_send(:"#{key}=", value) unless value.nil? }
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
