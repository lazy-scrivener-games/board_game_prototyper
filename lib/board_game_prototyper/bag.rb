# frozen_string_literal: true

class Bag < Collection
  def initialize(attributes = {})
    @y = 0.943
    super
    @tts_name = 'Bag'
  end

  def tts_config
    config = super
    config[:MaterialIndex] = -1
    config[:MeshIndex] = -1
    config[:Bag] = { Order: 0 }

    config
  end
end
