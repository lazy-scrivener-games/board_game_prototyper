# frozen_string_literal: true

require 'board_game_prototyper'

def book_subject
  book_game = game do
    output_path '/output/path'
    config_path '/config/path'
    name 'Book Spec Game'
    component 'book' do
      name 'Book Spec Book Name'
      tts_name 'Book Spec Book TTS'
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
      component do
        count 5
        compute 'guid', 'collection_number', base: true do |collection_number|
          "prose#{collection_number}"
        end
      end

      component ['cost', 'power'] do
        count 5
        compute 'guid', 'collection_number', base: true do |collection_number|
          "prose#{collection_number}"
        end
        name 'Book Spec Component'
        tts_name 'Book Spec Component'
        cost 5
        power 'overwhelming'
        tag 'cost', 'tag1'
        compute 'cost_display', 'cost' do
          append ' thingies'
        end
        compute 'power_split', 'power' do
          split('e')
        end
        compute 'doubled_integers', ['cost', 'power'] do
          filter { |_, value| value.is_a? Integer }
          multiply 2
        end
      end
      stats 'cost', 'max'
      stats %w[power length], 'min', 'average'
    end
  end
  book_game.components[0]
end
