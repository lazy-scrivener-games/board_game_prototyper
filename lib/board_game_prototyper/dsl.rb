# frozen_string_literal: true

# require_relative 'game'

module BoardGamePrototyper
  module Dsl
    def self.included(base)
      base.send :include, InstanceMethods
      base.extend ClassMethods
    end

    module InstanceMethods
      def attributes
        attrs = {}
        instance_variables.map do |name|
          key = name.to_s[1..-1]
          # next if %w[collection game components].include?(key)
          value = instance_variable_get(name)
          if value.respond_to? :attributes
            value = value.attributes
          end
          attrs[key] = value
        end
        attrs
      end

      # def set_attrs(*attrs)
        # self.class.set_attrs(attrs)
      # end
    end

    module ClassMethods
      def set_attrs(*attrs)
        attr_writer(*attrs)

        not_provided = Object.new
        attrs.each do |attr|
          define_method attr do |value = not_provided, &block|
            if value != not_provided
              instance_variable_set("@#{attr}", value)
            elsif block
              instance_variable_set("@#{attr}", instance_eval(&block))
            else
              result = instance_variable_get("@#{attr}")
              result.is_a?(Proc) ? instance_eval(&result) : result
            end
          end
        end
      end
    end
  end
end

require 'board_game_prototyper/game'
GAME = Game.new(components: [], new_save: 'new_save')

%w[bag deck infinite_bag].each do |type|
  define_method type do |&block|
    component(type, &block)
  end
end

def component(name, &block)
  unless block_given?
    require_relative(Rails.root.join(name))
    return
  end

  klass = name.classify.constantize

  c = klass.new(game: GAME)
  c.instance_eval(&block)
  return c if c.disabled
  raise "#{klass} #{c} is invalid: #{c.errors.messages}" if c.invalid?

  c.game.components << c

  c
end

def load_component_file(filename)
  puts filename
  require_relative(filename)
end

def load_component_files(pattern)
  Dir.glob(pattern, base: GAME.config_path) do |filename|
    puts filename
    load_component_file(File.expand_path(File.join(GAME.config_path, filename)))
  end
end

def components(filenames)
  Dir.glob(filenames).each do |file|
    load_component_file file
  end
end


def game(&block)
  GAME.instance_eval(&block)
  raise "Game #{GAME} is invalid: #{GAME.errors.messages}" if GAME.invalid?

  GAME
end
