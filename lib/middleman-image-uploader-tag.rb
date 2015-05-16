require 'middleman-core'
require_relative 'middleman/image-uploader-tag/extension'
require_relative 'middleman/image-uploader-tag/cdns/base.rb'
require_relative 'middleman/image-uploader-tag/cdns/cloudinary.rb'

::Middleman::Extensions.register(
  :image_uploader_tag, ::Middleman::ImageUploaderTag::ImageUploaderTagExtension
)
