require 'middleman-core'
require 'middleman-core/extensions'

module Middleman
  module ImageUploaderTag

    class Extension < ::Middleman::Extension
      option :provider, nil, 'CDN provider name'
      option :provider_config, nil, 'CDN provider config options'
      option :remote_images_dir, nil, %q{
        Folder where images are placed.
        Must be outside the :images_dir of the Middleman'
      }

      def initialize(app, options_hash = {}, &block)
        super

        # Require libraries only when activated
        # require 'necessary/library'

        @@provider_options = options
        @@app = app

        self.class.create_images_dir!
      end

      helpers do
        def remote_image_tag(image_name, params = {})
          image_tag remote_image_tag_link(image_name), params
        end

        def remote_image_tag_link(image_name)
          klass = ::Middleman::ImageUploaderTag::Extension

          klass.get_remote_path image_name
        end
      end

      def self.image_location(image_path)
        File.join(app.root, 'source', remote_images_dir, image_path)
      end

      def self.provider
        # need cache here i believe
        # handle cases for snake_case_name
        # handle unknown provider
        Object.const_get(
          "::Middleman::ImageUploaderTag::#{provider_options.provider.to_s.capitalize}CDN"
        ).new(provider_options.provider_config)
      end

      def self.get_remote_path(image_name)
        image_path = image_location(image_name)
        raise NotFound unless File.exist?(image_path)

        if app.config.environment == :build
          provider.get_remote_link(image_path)
        else
          image_name
        end
      end

      def self.provider_options
        @@provider_options
      end

      def self.app
        @@app
      end

      def self.remote_images_dir
        @@remote_images_dir ||= provider_options.remote_images_dir || 'remote_images'
      end

      def self.create_images_dir!
        img_dir = File.join(app.root, 'source', remote_images_dir)

        Dir.mkdir(img_dir) unless Dir.exist?(img_dir)
      end
    end

  end
end

