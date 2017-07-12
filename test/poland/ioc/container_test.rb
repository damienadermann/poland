require "test_helper"
require "poland/ioc/container"

describe Poland::IOC::Container do
  before do
    @container = Poland::IOC::Container.new
  end

  after do
    TestClass.reset
  end

  describe "#[]" do
    it "resolves a bound value" do
      @container.instance(:test, :test_value)

      assert_equal @container[:test], :test_value
    end

    it "raises an exception if container name has not yet been set" do
      assert_have_error("Unset Container name: invalid", Poland::IOC::InvalidContainerNameError) do
        @container[:invalid]
      end
    end
  end

  describe "#instance" do
    it "uses an instance of an object" do
      @container.instance(:test, :test_value)

      assert_equal @container[:test], :test_value
    end
  end

  describe "#bind" do
    it "creates a single shared instance of an object" do
      @container.bind(:test_class) { TestClass.new }
      instance1 = @container[:test_class]
      instance2 = @container[:test_class]

      assert_equal instance1, instance2
      assert_kind_of(TestClass, instance1)

      assert_equal 1, instance1.instance_number
      assert_equal 1, instance2.instance_number
    end

    it "creates a single instance of an object with bound container values" do
      @container.bind(:test_class) { |container| TestClass.new(container[:test_value]) }
      @container.instance(:test_value, :test_arg)
      instance = @container[:test_class]

      assert_equal :test_arg, instance.arg
    end
  end

  describe "#factory" do
    it "creates a new instance of an object each time" do
      @container.factory(:test_class) { TestClass.new }
      instance1 = @container[:test_class]
      instance2 = @container[:test_class]

      assert_kind_of(TestClass, instance1)

      assert_equal 1, instance1.instance_number
      assert_equal 2, instance2.instance_number
    end

    it "creates an of an object with bound container values" do
      @container.factory(:test_class) { |container| TestClass.new(container[:test_value]) }
      @container.instance(:test_value, :test_arg)
      instance = @container[:test_class]

      assert_equal :test_arg, instance.arg
    end
  end

  describe "#alias" do
    it "resolves an aliased container name" do
      @container.instance(:test, :test_value)
      @container.alias(:test_alias, :test_value)
      assert_equal :test_value, @container[:test_alias]
    end
  end

  describe "#bind_class" do
    it "creates a single shared instance of a class" do
      @container.bind_class(:test_class, TestClass)
      instance1 = @container[:test_class]
      instance2 = @container[:test_class]

      assert_equal instance1, instance2
      assert_kind_of(TestClass, instance1)

      assert_equal 1, instance1.instance_number
      assert_equal 1, instance2.instance_number
    end

    it "creates a single instance of a class with args resolved to bound container values" do
      @container.bind_class(:test_class, TestClass, :test_value)
      @container.instance(:test_value, :test_arg)
      instance = @container[:test_class]

      assert_equal :test_arg, instance.arg
    end
  end

  class TestClass
    class << self
      attr_accessor :instance_count

      def instance_count_incrememnt
        self.instance_count = if instance_count
                                instance_count + 1
                              else
                                1
                              end
      end

      def reset
        self.instance_count = 0
      end
    end

    attr_reader :instance_number, :arg

    def initialize(arg = nil)
      @instance_number = self.class.instance_count_incrememnt
      @arg = arg
    end
  end
end
