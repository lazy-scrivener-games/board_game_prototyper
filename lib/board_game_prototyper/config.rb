class Config
  extend Forwardable
  def_delegators :@config, :delete, :each, :[], :[]=, :to_hash, :to_s
  def initialize
    @config = {}.with_indifferent_access
  end

  def method_missing(name, *args, &block)
    return @config[name] if args.empty?

    @config[name] = args[0]
  end
end
