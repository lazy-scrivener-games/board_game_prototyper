# frozen_string_literal: true

class InfiniteBag < Bag
  validates :components, length: {maximum: 1}

  def initialize(attributes = {})
    super
    @tts_name = 'Infinite_Bag'
  end
end
