# frozen_string_literal: true

require 'board_game_prototyper/dsl'

# Prose class
class Prose < Component
  include BoardGamePrototyper::Dsl
  set_attrs(:text, :number)

  def initialize(attributes = {})
    super
  end
end
