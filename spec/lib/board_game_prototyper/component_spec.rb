# frozen_string_literal: true

RSpec.describe Component do
  context 'with only game' do
    subject { Component.new(game: GAME) }
    it { should be_invalid }
  end

  context 'with minimum fields' do
    subject { Component.new(game: Game.new, tts_name: 'tts_name', x: 0, rot_x: 0, y: 0, rot_y: 0, z: 0, rot_z: 0) }
    it { should be_valid }
    its(:tts_name) { should be 'tts_name' }
    its(:name) { should be_nil }
    its(:x) { should be 0 }
    its(:rot_x) { should be 0 }
    its(:y) { should be 0 }
    its(:rot_y) { should be 0 }
    its(:z) { should be 0 }
    its(:rot_z) { should be 0 }
    its(:images) { should be false }
    its(:guid) { should(satisfy { |g| g.size == 6 }) }
    its(:hands) { should be true }
    its(:id) { should eq 1 }
    its(:game) { should be_kind_of(Game) }
    its(:view_name) { should be_nil }
    its(:images) { should be false }
    its(:r) { should eq 0.71 }
    its(:b) { should eq 0.71 }
    its(:g) { should eq 0.71 }
    its(:scale_x) { should eq 1.0 }
    its(:scale_y) { should eq 1.0 }
    its(:scale_z) { should eq 1.0 }
    its(:collection) { should be_nil }
    its(:hands) { should be true }
    its(:locked) { should be_nil }
    its(:disabled) { should be_nil }
    specify { expect(subject.to_s).to eq 'Component: ' }
  end
end
