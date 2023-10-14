# frozen_string_literal: true

require 'board_game_prototyper'

def collection_subject
  collection_game = game do
    output_path '/output/path'
    config_path '/config/path'
    name 'Collection Spec Game'
    component 'collection' do
      name 'Collection Spec Collection Name'
      tts_name 'Collection Spec Collection TTS'
      x 1
      rot_x 2
      y 3
      rot_y 4
      z 5
      rot_z 6
      r 7
      g 8
      b 9
      scale_x 10
      scale_y 11
      scale_z 12
      guid 'guid'
      id 99
      view_name 'view_name'
      images true
      hands false
      locked true
      component ['cost', 'i'] do
        count 5
        compute 'guid', 'i', base: true do |i|
          "comp#{i}"
        end
        name 'Collection Spec Component'
        tts_name 'Collection Spec Component'
        cost 5
        tag 'cost', 'tag1'
        compute 'cost_display', 'cost', base: true do |cost|
          "#{cost} thingies"
        end
      end
      stats 'cost', 'max'
    end
  end
  collection_game.components[0]
end
