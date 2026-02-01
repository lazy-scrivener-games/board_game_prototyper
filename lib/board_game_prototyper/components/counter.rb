# frozen_string_literal: true

class Counter < Component
  include BoardGamePrototyper::Dsl
  set_attrs(:value)

  def initialize(attributes = {})
    super
    @hands = false
    @tts_name = 'Counter'
  end

  def tts_config
    config = super
    config[:Counter] = {value: value}

    config
  end
end
