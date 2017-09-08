module Poland
  module IOC
    class InstanceResolver
      def initialize(value)
        @value = value
      end

      def resolve
        @value
      end
    end
  end
end
