require 'middleman-core'
require 'middleman-core/extensions'

module Middleman
  module ImageUploaderTag

    class ImageUploaderTagExtension < ::Middleman::Extension
      option :cloudinary, nil, 'Cloudinary API options'

      def initialize(app, options_hash={}, &block)
        super

        # Require libraries only when activated
        # require 'necessary/library'
        # puts options.my_option
        #app.send :include, Helpers
      end

      helpers do
        def remote_image_tag(image_path, params={})
          klass = ::Middleman::ImageUploaderTag::ImageUploaderTagExtension

          image_tag klass.get_remote_path(klass.provider, image_path), params
        end
      end

      def after_configuration
        # Do something
      end
      #
      # A Sitemap Manipulator
      # def manipulate_resource_list(resources)
      # end
      #
      def self.provider
        :cloudinary
      end

      def self.get_remote_path(provider, image_path)
        "https://res.cloudinary.com/aliaksandrb/image/upload/t_media_lib_thumb/v1431639342/sample.jpg"
      end

      #alias :included :registered
    end

  end
end


