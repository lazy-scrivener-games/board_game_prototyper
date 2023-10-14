# frozen_string_literal: true

# This class is used to allow for an easier time inside the `compute` keyword
# Each line inside a `compute` block evaluates against @source and then
# @source is set to the result. This allows for example, chaining filter and map
# It also provides some helper methods like `append` and `multiply` to assist in
# cases where the desired behavior a method directly on the @source.
class Rollable
  extend Forwardable
  def_delegators :@source, :to_s
  def initialize(source)
    @source = source.dup
  end

  # TODO: Build out helper methods
  # Other helpers: divide, add, subtract
  def multiply(num)
    @source = case @source
              when Array
                @source.map { |value| value * num }
              when Hash
                @source.transform_values { |value| value * num }
              else
                @source * num
              end
  end

  def append(to_append)
    @source = "#{@source}#{to_append}"
  end

  def method_missing(method_name, *args, &)
    @source = @source.send(method_name, *args, &)
  end

  def respond_to_missing?(method_name, include_private = false)
    @source.respond_to?(method_name, include_private)
  end
end
