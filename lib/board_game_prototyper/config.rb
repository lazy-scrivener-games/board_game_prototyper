class Config
  extend Forwardable
  def_delegators :@config, :delete, :each, :[], :[]=, :to_hash, :to_s
  def initialize(component_class)
    @component_class = component_class
    @config = {}.with_indifferent_access
  end

  def method_missing(name, *args, **kwargs, &block)
    return @config[name] if args.empty?

    return @component_class.send(name, *args, **kwargs, &block) if %i[tag compute].include? name.to_sym

    @config[name] = args[0]
  end
end
