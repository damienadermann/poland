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
end
