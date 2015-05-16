require 'middleman-core'
require 'middleman-core/extensions'

module Middleman
  module ImageUploaderTag

    class ImageUploaderTagExtension < ::Middleman::Extension
      cattr_reader :provider_options

      option :provider, nil, 'CDN provider name'
      option :provider_config, nil, 'CDN provider config options'

      def initialize(app, options_hash={}, &block)
        super

        # Require libraries only when activated
        # require 'necessary/library'
        #app.send :include, Helpers
        @@provider_options = options
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
        Object.const_get(
          "::Middleman::ImageUploaderTag::#{provider_options.provider.to_s.capitalize}"
        ).new(provider_options.provider_config)
      end

      def self.get_remote_path(provider, image_path)
        provider.get_remote_link(image_path)
      end

      #alias :included :registered
    end

  end
end


