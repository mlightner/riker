require 'rspec'
require 'riker'

RSpec::Matchers.define :have_attr_accessor do |attribute|
  match do |object|
    object.respond_to?(attribute) && object.respond_to?("#{attribute}=")
  end

  description do
    "have attr_accessor :#{attribute}"
  end
end

RSpec::Matchers.define :have_attr_reader do |attribute|
  match do |object|
    object.respond_to? attribute
  end

  description do
    "have attr_reader :#{attribute}"
  end
end

RSpec::Matchers.define :have_attr_writer do |attribute|
  match do |object|
    object.respond_to? "#{attribute}="
  end

  description do
    "have attr_writer :#{attribute}"
  end
end

RSpec::Matchers.define :get_or_set do |attribute|
  match do |object|
    can_get?(object, attribute) && can_set?(object, attribute)
  end

  def can_get?(object, attribute)
    object.send(attribute, :test_value)
    object.instance_variable_get("@#{attribute}") == :test_value
  end

  def can_set?(object, attribute)
    object.instance_variable_set("@#{attribute}", :test_value)
    object.send(attribute) == :test_value
  end

  description do
    "get or set @#{attribute} with ##{attribute}"
  end
end

class TestDriver
  def say_my_name(*args)
    :test_driver
  end
end
