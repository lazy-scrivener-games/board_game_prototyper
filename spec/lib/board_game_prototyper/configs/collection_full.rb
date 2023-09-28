# frozen_string_literal: true

require 'board_game_prototyper'

def collection_subject
  collection_game = game do
    name 'Collection Spec Game'
    component('collection') do
      name 'Collection Spec Collection'
      tts_name 'Collection Spec Collection'
      x 1
      rot_x 2
      y 3
      rot_y 4
      z 5
      rot_z 6
      r 7
      g 8
      b 9
      component do
        name 'Collection Spec Component'
        tts_name 'Collection Spec Component'
      end
    end
  end
  collection_game.components[0]
end
      # collection = described_class.new(game:, tts_name: 'tts_name', x: 1, rot_x: 2, y: 3, rot_y: 4, z: 5, rot_z: 6,
                          # r: 7, g: 8, b: 9, scale_x: 10, scale_y: 11, scale_z: 12, guid: 'guid', id: 99, name: 'name',
                          # view_name: 'view_name', images: true, hands: false, component_class: 'component',
                          # locked: true, disabled: false)
