# frozen_string_literal: true
require 'board_game_prototyper/dsl'

class Die < Component
  include BoardGamePrototyper::Dsl
  set_attrs(:rotations, :faces, :material_index, :top)

  def initialize(attributes = {})
    super
    @top ||= 1
    set_faces
    set_top
    @view_name = '_die'
    @material_index ||= 1
    @tts_name = "Die_#{@faces.size}"
    @hands = attributes[:hands] || false
  end

  def set_faces
    @faces = []
    rotations.each_with_index do |values, i|
      x, y, z = values
      @faces << {
        Value: (i + 1).to_s,
        Rotation: {
          x: x,
          y: y,
          z: z
        }
      }.with_indifferent_access
    end
  end

  def tts_config
    config = super
    config[:HideWhenFaceDown] = false
    config[:AltSound] = true
    config[:MaterialIndex] = material_index
    config[:LuaScript] = ''
    config[:LuaScriptState] = ''
    config[:RotationValues] = faces

    config
  end
end
