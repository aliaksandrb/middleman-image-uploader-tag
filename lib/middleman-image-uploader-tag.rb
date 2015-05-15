require 'middleman-core'
require_relative 'middleman/image-uploader-tag/extension'

::Middleman::Extensions.register(
  :image_uploader_tag, ::Middleman::ImageUploaderTag::ImageUploaderTagExtension
)
