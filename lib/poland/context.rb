module Poland
  class Context
    class << self
      def config(&block)
        @initialize_config = block
      end

      def initialize_config
        @initialize_config || Proc.new {}
      end

      def container(&block)
        @initialize_container = block
      end

      def initialize_container
        @initialize_container || Proc.new {}
      end
    end

    attr_reader :config, :container

    def initialize(config: {}, container: IOC::Container.new)
      @config = config
      @container = container
      load_config
      build_container
    end

    private

    def load_config
      instance_exec(config, &self.class.initialize_config)
    end

    def build_container
      instance_exec(container, &self.class.initialize_container)
    end
  end
end
