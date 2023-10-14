# frozen_string_literal: true

class D6 < Die
  def initialize(_attributes = {})
    @faces = []
    @rotations = [[-90, 0, 0], [0, 0, 0], [0, 0, -90], [0, 0, 90], [0, 0, -180], [90, 0, 0]]
    super
  end

  def set_top
    tops = {
      1 => [270, 0, 0],
      2 => [0, 0, 0],
      3 => [0, 0, 270],
      4 => [0, 0, 90],
      5 => [0, 0, 180],
      6 => [90, 0, 0]
    }

    @rot_x, @rot_y, @rot_z = tops[top]
  end
end
