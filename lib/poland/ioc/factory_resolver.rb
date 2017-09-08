module Poland
  module IOC
    class FactoryResolver
      def initialize(container, block)
        @container = container
        @block = block
      end

      def resolve
        @block.call(@container)
      end
    end
  end
end
