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

public

def game(&block)
  game_object = Game.new(name: 'dsl-base', components: [], new_save: 'new_save')
  game_object.instance_eval(&block)
  raise "Game #{game_object} is invalid: #{game_object.errors.messages}" if game_object.invalid?

  game_object
end
