class Rollable
  extend Forwardable
  def_delegators :@source, :to_s
  def initialize(source)
    @source = source.dup
  end

  # TODO: Build out helper methods
  # Other helpers: divide, add, subtract
  def multiply(x)
    @source = case @source
              when Integer
                @source * x
              when Array
                @source.map { |value| value * x }
              when Hash
                @source.transform_values { |value| value * x }
              else
                @source
              end
  end

  def append(to_append)
    @source = "#{@source}#{to_append}"
  end

  def method_missing(m, *args, &)
    @source = @source.send(m, *args, &)
  end
end

