# frozen_string_literal: true

require 'board_game_prototyper'

def deck_subject
  deck_game = game do
    output_path '/output/path'
    config_path 'spec/fixtures'
    name 'Deck Spec Game'
    deck do
      name 'Deck Spec Deck Name Minimal'
      tts_name 'Deck Spec Deck TTS'
      # card ['i'] do
      card do
        count 5
        name 'test card'
        compute 'guid', 'collection_number', base: true do |collection_number|
          "card#{collection_number}"
        end
      end
    end
  end
  deck_game.components[0]
end
