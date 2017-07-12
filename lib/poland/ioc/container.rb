module Poland
  module IOC
    class Container
      def bind(name, &block)
        add_resolver(name, BindResolver.new(self, block))
      end

      def instance(name, value)
        add_resolver(name, InstanceResolver.new(value))
      end

      def factory(name, &block)
        add_resolver(name, FactoryResolver.new(self, block))
      end

      def alias(name, aliased_container_name)
        add_resolver(name, AliasResolver.new(self, aliased_container_name))
      end

      def bind_class(name, klass, *args)
        add_resolver(name, ClassResolver.new(self, klass, args))
      end

      def [](container_name)
        resolve(container_name)
      end

      private

      def resolve(container_name)
        resolver = resolvers.fetch(container_name) { NullResolver.new(container_name) }
        resolver.resolve
      end

      def add_resolver(name, resolver)
        resolvers[name] = resolver
      end

      def resolvers
        @resolvers ||= {}
      end
    end

    class BindResolver
      def initialize(container, block)
        @container = container
        @block = block
      end

      def resolve
        @resolved_instance ||= @block.call(@container)
      end
    end

    class FactoryResolver
      def initialize(container, block)
        @container = container
        @block = block
      end

      def resolve
        @block.call(@container)
      end
    end

    class InstanceResolver
      def initialize(value)
        @value = value
      end

      def resolve
        @value
      end
    end

    class AliasResolver
      def initialize(container, aliased_container_name)
        #@container = container
        @aliased_container_name = aliased_container_name
      end

      def resolve
        @container[aliased_container_name]
      end
    end

    class ClassResolver
      def initialize(container, klass, args)
        @container = container
        @klass = klass
        @args = args
      end

      def resolve
        @resolved_instance ||= @klass.new(*resolved_arguments)
      end

      private

      def resolved_arguments
        @args.map do |arg|
          @container[arg]
        end
      end
    end

    class NullResolver
      def initialize(name)
        @name = name
      end

      def resolve
        raise InvalidContainerNameError, "Unset Container name: #{@name}"
      end
    end

    class InvalidContainerNameError < StandardError; end
  end
end
