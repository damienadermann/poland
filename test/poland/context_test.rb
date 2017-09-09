require "test_helper"
require "poland"

describe Poland::Context do

  after do
    TestClass.reset
  end

  describe "config" do
    before(:suite) do
      class Context < Poland::Context
        config do |config|
          config[:key] = :value
        end
      end
    end

    it "configures its own config" do
      context = Context.new

      assert_equal(context.config, {key: :value})
    end

    it "configures it receives a config on initialization" do
      context = Context.new(config: {key1: :value})

      assert_equal(context.config, {key: :value, key1: :value})
    end
  end

  describe "container" do
    before(:suite) do
      class Context < Poland::Context
        config do |config|
          config[:key] = :value
        end

        container do |container|
          container.instance :test, config[:key]
        end
      end
    end

    it "builds its own container" do
      context = Context.new

      assert_equal(context.container[:test], :value)
    end

    it "it can use an existing container" do
      container = Poland::IOC::Container.new
      container.instance(:preexisted?, true)
      context = Context.new(container: container)

      assert_equal(context.container[:preexisted?], true)
    end
  end
end
