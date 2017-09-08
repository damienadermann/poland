module Poland
  module IOC
    class NullResolver
      def initialize(name)
        @name = name
      end

      def resolve
        raise InvalidContainerNameError, "Unset Container name: #{@name}"
      end
    end
  end
end
