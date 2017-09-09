module Poland
  class Context
    class << self
      def config(&block)
        @initialize_config = block
      end

      def initialize_config
        @initialize_config || Proc.new {}
      end
    end

    attr_reader :config

    def initialize(config: {})
      @config = config
      load_config
    end

    private

    def load_config
      self.class.initialize_config.call(config)
    end
  end
end
