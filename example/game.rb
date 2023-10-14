# frozen_string_literal: true

require 'board_game_prototyper/dsl'
# require_relative '../lib/data/dsl'
# require 'tts_prototyper/dsl'

rogue_ai = game do
  name 'Example'
  version 'v1'
  base_save 'DecklessSetup.json'
  new_save 'save.json'
  tts_save_path '/home/elim/.local/share/Tabletop Simulator/Saves/'
  output_path '/home/elim/code/rogue_ai/output'
  cider_path '/home/elim/code/rogue_ai/data/cider'

  # Dir.glob('data/decks/*.rb').each do |deck_file|
    # load_component_file deck_file
  # end
  # Dir.glob('data/bags/*.rb').each do |bag_file|
    # load_component_file bag_file
  # end
  component 'counter' do
    name 'Alert'
    # type "Counter"
    value 0
    x(-5)
  end
end

puts "Game #{rogue_ai.name} loaded"

rogue_ai.components.each do |component|
  puts component.name
end

rogue_ai.tts_config
