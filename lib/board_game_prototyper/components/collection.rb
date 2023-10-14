# frozen_string_literal: true

require 'csv'
require 'easystats'
require 'board_game_prototyper/util/config'
require 'board_game_prototyper/util/rollable'

class Collection < Component
  extend Forwardable
  def_delegators :@components, :each, :<<, :first, :last
  def_delegators :@component_class, :tags

  set_attrs :component_class, :components

  def stats(attr = nil, *stat_methods)
    @stats ||= {}
    return @stats.with_indifferent_access if attr.nil?

    stats = {}
    stat_name = attr
    if attr.is_a? Array
      stat_name = attr.join('.')
      field = attr.shift
      fields = components.map { |component| component.instance_variable_get("@#{field}") }
      attr.each do |method|
        fields = fields.map(&method.to_sym)
      end
    else
      fields = components.map { |component| component.instance_variable_get("@#{attr}") }
    end
    stat_methods.each do |stat|
      # was here
      # TODO: better handling for 'X' as a cost
      fields = fields.filter { |x| !x.is_a? String }
      stats[stat] = fields.instance_eval(stat)
    end
    @stats[stat_name] = stats
  end

  def build_component_class(component_fields, subtype = nil)
    klass = Class.new(@component_base_class) do
      @tags = {}
      @dynamic_attributes = {}
      class << self
        include BoardGamePrototyper::Dsl
        set_attrs :tags, :dynamic_attributes, :tts_name

        def tag(attr, tag_name)
          @tags[tag_name] ||= []
          @tags[tag_name].append attr
        end

        def compute(attr, keys, base: false, default: 'this is the default value', &block)
          attr_accessor(attr)

          instance_variable_set("@#{attr}_source", block.source_location)

          dynamic_attributes[attr] = lambda do |instance|
            # define_method(attr) do
            return default unless keys

            source = if keys.is_a? Array
                       keys.map { |key| [key, instance.instance_variable_get("@#{key}")] }.to_h
                     else
                       instance.instance_variable_get("@#{keys}")
                     end

            return default unless source

            if base
              rollable = Rollable.new(base)
              rollable.instance_exec(source, &block)
            else
              rollable = Rollable.new(source)
              rollable.instance_eval(&block)
            end
          end
        end

        # TODO: Ideally merge this in with the other attributes bits
        def attributes
          attrs = {}
          instance_variables.map do |name|
            key = name.to_s[1..-1]
            next if dynamic_attributes.keys.include? key.sub(/_source$/, '')

            value = instance_variable_get(name)
            if key == 'dynamic_attributes'
              value.each do |dkey, dvalue|
                value[dkey] = instance_variable_get("@#{dkey}_source") if dvalue.is_a? Proc
              end
            end
            if value.respond_to? :attributes
              value = value.attributes
            elsif value.is_a? Proc
              instance_eval(&value)
            end
            attrs[key] = value
          end
          attrs
        end
      end

      attr_accessor(*component_fields)

      def initialize(attributes = {})
        @tts_name = self.class.tts_name
        super
        self.class.dynamic_attributes.each_pair do |attr, block|
          value = if block.is_a? Proc
                    instance_eval(&block)
                  else
                    block
                  end
          instance_variable_set("@#{attr}", value)
        end
      end
    end

    klass_name = name.gsub(' ', '_').classify
    klass_name += subtype.classify if subtype

    # @component_class = klass
    @component_class = Component.const_set(klass_name, klass)
  end

  %w[d6].each do |type|
    define_method type do |&block|
      klass = type.classify.constantize

      c = klass.new(game:)
      c.instance_eval(&block)
      raise "#{klass} #{c} is invalid: #{c.errors.messages}" if c.invalid?

      components << c

      c
    end
  end

  def component(fields = [], &)
    return @components[0] unless block_given?

    build_component_class(fields)

    config = Config.new(component_class)
    config.instance_eval(&) if block_given?
    add_component(config)
  end

  def components(filename = nil, subtype = nil, &block)
    return @components if filename.nil? && block.nil?

    component_config = parse_component_file(filename)
    component_fields = component_config[0].keys

    build_component_class(component_fields, subtype)

    component_class.class_eval(&block) if block_given?

    load_components(component_config)
  end

  def initialize(attributes = {})
    attributes = attributes.with_indifferent_access
    @components = []
    @component_type ||= 'component'
    @component_base_class = Component
    components_config = attributes.delete("#{@component_type}s")
    super
    @hands ||= false
    # TODO: This might break things
    # Should I support this, or should we expect you to use the `components` block on the object?
    return unless components_config

    component_fields = components_config[0].keys

    subtype = components_config.delete('component_subtype')
    build_component_class(component_fields, subtype)

    load_components(components_config)

    # End of maybe breaking
    # load_components(components_config) if components_config
  end

  def guids
    components.map(&:guids).flatten.append(guid)
  end

  def parse_component_file(filename)
    filename = File.join(game.config_path, 'decks', filename)
    if filename.end_with? '.csv'
      components_config = CSV.read(filename, headers: true, converters: :numeric, header_converters: :symbol)
      components_config = components_config.map(&:to_h)
    else
      components_config = JSON.parse(File.read(filename))
    end
    components_config.map! { |row| row.deep_transform_keys { |key| key.to_s.downcase } }
    components_config
  end

  def load_components(components)
    components = parse_component_file(components) if components.is_a? String

    components.map { |component_config| add_component(component_config) }
  end

  def new_component(config, i)
    config[:collection] = self
    config[:game] = @game
    config[:i] = i
    klass = config.delete('component_class') || component_class
    klass = klass.classify.constantize if klass.is_a? String
    instance = klass.new(**config)
    raise "Component #{instance.name} is invalid: #{instance.errors.messages}" if instance.invalid?

    instance
  end

  def add_component(component)
    count = component.delete('count') || 1
    count.to_i.times do |i|
      # Easiest way to do this, Deck 5 had 500-599, deck 11 has 1100-199
      # Don't need to convert to int, just don't wrap with quotes in view
      component[:id] = "#{id}#{components.size.to_s.rjust(2, "0")}"
      components << new_component(component, i)
    end
  end

  def type
    component_class.to_s.underscore
  end

  def tts_config
    config = super
    config[:HideWhenFaceDown] = false
    config[:ContainedObjects] = components.map(&:tts_config) unless components.empty?

    config
  end
end
