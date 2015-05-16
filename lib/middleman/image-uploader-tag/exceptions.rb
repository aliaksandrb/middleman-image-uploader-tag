module Middleman
  module ImageUploaderTag

    class ImageUploaderTagException < StandardError;
      def initialize(msg = nil)
        @message = msg
        super
      end
    end

    class NotFound < ImageUploaderTagException;
      def to_s
        "#{self.class}: #{@message || 'No such image file in the remote folder'}"
      end
    end

  end
end
