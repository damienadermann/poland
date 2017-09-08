module Poland
  module IOC
    class BindResolver
      def initialize(container, block)
        @container = container
        @block = block
      end

      def resolve
        @resolved_instance ||= @block.call(@container)
      end
    end
  end
end
