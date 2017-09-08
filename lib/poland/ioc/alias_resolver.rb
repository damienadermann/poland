module Poland
  module IOC
    class AliasResolver
      def initialize(container, aliased_container_name)
        @container = container
        @aliased_container_name = aliased_container_name
      end

      def resolve
        @container[@aliased_container_name]
      end
    end
  end
end
