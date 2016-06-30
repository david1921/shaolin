require_relative '../../test_helper'

class DecoratorTest < ActiveSupport::TestCase

  setup do
    @object = "Hello"
    @decorator = Decorator.new(@object)
  end

  context "#initialize" do
    should "set the decorated instance" do
      assert @decorator.decorated.equal?(@object), "Should use the same instance of the object"
    end

    should "raise a DecoratingNil exception if the decorated instance is nil" do
      assert_raise(DecoratingNilException) { Decorator.new(nil) }
    end
  end

  context "#method_missing" do
    should "be able to call decorated object's instance methods" do
      assert_equal 5, @decorator.length, "Should be able to call decorated's (String) length method"
    end

    should "not be able to call methods missing from the decorated instance" do
      refute @decorator.respond_to?(:foo_bar_baz_boop)
    end
  end

end