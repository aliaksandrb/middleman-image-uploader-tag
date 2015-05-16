require 'middleman-core'
require 'middleman-core/extensions'

module Middleman
  module ImageUploaderTag

    class ImageUploaderTagExtension < ::Middleman::Extension
      option :provider, nil, 'CDN provider name'
      option :provider_config, nil, 'CDN provider config options'

      def initialize(app, options_hash = {}, &block)
        super

        # Require libraries only when activated
        # require 'necessary/library'
        #app.send :include, Helpers
        @@provider_options = options
      end

      helpers do
        def remote_image_tag(image_name, params = {})
          klass = ::Middleman::ImageUploaderTag::ImageUploaderTagExtension
          image_path = klass.image_location(image_name)

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

      def self.image_location(image_name)
        "/home/k3/Development/blog/source/images/test.png"
      end

      def self.provider
        Object.const_get(
          "::Middleman::ImageUploaderTag::#{provider_options.provider.to_s.capitalize}CDN"
        ).new(provider_options.provider_config)
      end

      def self.get_remote_path(provider, image_path)
        provider.get_remote_link(image_path)
      end

      def self.provider_options
        @@provider_options
      end
      #alias :included :registered
    end

  end
end


