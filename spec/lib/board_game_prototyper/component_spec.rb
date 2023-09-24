# frozen_string_literal: true

RSpec.describe Component do
  include FakeFS::SpecHelpers
  context 'with only game' do
    subject { described_class.new(game: GAME) }

    it { is_expected.not_to be_valid }
  end

  context 'with minimum fields' do
    subject(:component) do
      described_class.new(game: Game.new, tts_name: 'tts_name', x: 0, rot_x: 0, y: 0, rot_y: 0, z: 0, rot_z: 0)
    end

    it { is_expected.to be_valid }
    its(:tts_name) { is_expected.to be 'tts_name' }
    its(:name) { is_expected.to be_nil }
    its(:x) { is_expected.to be 0 }
    its(:rot_x) { is_expected.to be 0 }
    its(:y) { is_expected.to be 0 }
    its(:rot_y) { is_expected.to be 0 }
    its(:z) { is_expected.to be 0 }
    its(:rot_z) { is_expected.to be 0 }
    its(:images) { is_expected.to be false }
    its(:guid) { is_expected.to eq '75ddba' }
    its(:guids) { is_expected.to eq ['75ddba'] }
    its(:hands) { is_expected.to be true }
    its(:id) { is_expected.to eq 1 }
    its(:game) { is_expected.to be_a(Game) }
    its(:view_name) { is_expected.to be_nil }
    its(:r) { is_expected.to eq 0.71 }
    its(:b) { is_expected.to eq 0.71 }
    its(:g) { is_expected.to eq 0.71 }
    its(:scale_x) { is_expected.to eq 1.0 }
    its(:scale_y) { is_expected.to eq 1.0 }
    its(:scale_z) { is_expected.to eq 1.0 }
    its(:collection) { is_expected.to be_nil }
    its(:locked) { is_expected.to be_nil }
    its(:disabled) { is_expected.to be_nil }
    specify { expect(component.to_s).to eq 'Component: ' }
    its(:inspect) { is_expected.to eq 'Component: ' }

    it 'cannot get an image path without a name' do
      expect do
        component.image_path('ending')
      end.to raise_error(NoMethodError, "undefined method `gsub' for nil:NilClass")
    end

    context 'the tts_config' do
      subject(:tts_config) { component.tts_config }

      its([:GUID]) { is_expected.to eq '75ddba' }
      its([:Name]) { is_expected.to be 'tts_name' }
      its(%i[Transform posX]) { is_expected.to be 0 }
      its(%i[Transform posY]) { is_expected.to be 0 }
      its(%i[Transform posZ]) { is_expected.to be 0 }
      its(%i[Transform rotX]) { is_expected.to be 0 }
      its(%i[Transform rotY]) { is_expected.to be 0 }
      its(%i[Transform rotZ]) { is_expected.to be 0 }
      its(%i[Transform scaleX]) { is_expected.to be 1.0 }
      its(%i[Transform scaleY]) { is_expected.to be 1.0 }
      its(%i[Transform scaleZ]) { is_expected.to be 1.0 }
      its([:Nickname]) { is_expected.to be_nil }
      its([:Description]) { is_expected.to be '' }
      its([:GMNotes]) { is_expected.to be '' }
      its(%i[AltLookAngle x]) { is_expected.to be 0.0 }
      its(%i[AltLookAngle y]) { is_expected.to be 0.0 }
      its(%i[AltLookAngle z]) { is_expected.to be 0.0 }
      its(%i[ColorDiffuse r]) { is_expected.to be 0.71 }
      its(%i[ColorDiffuse g]) { is_expected.to be 0.71 }
      its(%i[ColorDiffuse b]) { is_expected.to be 0.71 }
      its([:LayoutGroupSortIndex]) { is_expected.to be 0 }
      its([:Value]) { is_expected.to be 0 }
      its([:Locked]) { is_expected.to be false }
      its([:Grid]) { is_expected.to be true }
      its([:Snap]) { is_expected.to be true }
      its([:IgnoreFoW]) { is_expected.to be false }
      its([:MeasureMovement]) { is_expected.to be false }
      its([:Autoraise]) { is_expected.to be true }
      its([:Sticky]) { is_expected.to be true }
      its([:Tooltip]) { is_expected.to be true }
      its([:GridProjection]) { is_expected.to be false }
      its([:Hands]) { is_expected.to be true }
      its([:XmlUI]) { is_expected.to be '' }
    end
  end

  context 'with all fields' do
    subject(:component) do
      game = Game.new
      game.config_path = '/config/path'
      game.output_path = '/output/path'
      described_class.new(game:, tts_name: 'tts_name', x: 1, rot_x: 2, y: 3, rot_y: 4, z: 5, rot_z: 6, r: 7,
                          g: 8, b: 9, scale_x: 10, scale_y: 11, scale_z: 12, guid: 'guid', id: 99, name: 'name',
                          view_name: 'view_name', images: true, collection: Collection.new(game:), hands: false,
                          locked: true, disabled: false)
    end

    it { is_expected.to be_valid }
    its(:tts_name) { is_expected.to be 'tts_name' }
    its(:name) { is_expected.to be 'name' }
    its(:x) { is_expected.to be 1 }
    its(:rot_x) { is_expected.to be 2 }
    its(:y) { is_expected.to be 3 }
    its(:rot_y) { is_expected.to be 4 }
    its(:z) { is_expected.to be 5 }
    its(:rot_z) { is_expected.to be 6 }
    its(:images) { is_expected.to be false }
    its(:guid) { is_expected.to be 'guid' }
    its(:guids) { is_expected.to eq ['guid'] }
    its(:hands) { is_expected.to be true }
    its(:id) { is_expected.to eq 99 }
    its(:game) { is_expected.to be_a(Game) }
    its(:view_name) { is_expected.to be 'view_name' }
    its(:r) { is_expected.to eq 7 }
    its(:g) { is_expected.to eq 8 }
    its(:b) { is_expected.to eq 9 }
    its(:scale_x) { is_expected.to eq 10 }
    its(:scale_y) { is_expected.to eq 11 }
    its(:scale_z) { is_expected.to eq 12 }
    its(:collection) { is_expected.to be_a(Collection) }
    its(:locked) { is_expected.to be true }
    its(:disabled) { is_expected.to be false }
    specify { expect(component.to_s).to eq 'Component: name' }
    its(:inspect) { is_expected.to eq 'Component: name' }
    its(:recursive_attributes) { is_expected.to eq({}) }

    it 'generates an image path successfully' do
      expect(component.image_path('ending')).to eq '/config/path/output/images/component/name_ending-guid.png'
    end

    it 'generates an image path successfully from output path' do
      expect(component.image_path('ending', config: true)).to eq '/output/path/images/component/name_ending-guid.png'
    end

    context 'the tts_config' do
      subject(:tts_config) { component.tts_config }

      its([:GUID]) { is_expected.to be 'guid' }
      its([:Name]) { is_expected.to be 'tts_name' }
      its(%i[Transform posX]) { is_expected.to be 1 }
      its(%i[Transform posY]) { is_expected.to be 3 }
      its(%i[Transform posZ]) { is_expected.to be 5 }
      its(%i[Transform rotX]) { is_expected.to be 2 }
      its(%i[Transform rotY]) { is_expected.to be 4 }
      its(%i[Transform rotZ]) { is_expected.to be 6 }
      its(%i[Transform scaleX]) { is_expected.to be 10 }
      its(%i[Transform scaleY]) { is_expected.to be 11 }
      its(%i[Transform scaleZ]) { is_expected.to be 12 }
      its([:Nickname]) { is_expected.to be 'name' }
      its([:Description]) { is_expected.to be '' }
      its([:GMNotes]) { is_expected.to be '' }
      its(%i[AltLookAngle x]) { is_expected.to be 0.0 }
      its(%i[AltLookAngle y]) { is_expected.to be 0.0 }
      its(%i[AltLookAngle z]) { is_expected.to be 0.0 }
      its(%i[ColorDiffuse r]) { is_expected.to be 7 }
      its(%i[ColorDiffuse g]) { is_expected.to be 8 }
      its(%i[ColorDiffuse b]) { is_expected.to be 9 }
      its([:LayoutGroupSortIndex]) { is_expected.to be 0 }
      its([:Value]) { is_expected.to be 0 }
      its([:Locked]) { is_expected.to be true }
      its([:Grid]) { is_expected.to be true }
      its([:Snap]) { is_expected.to be true }
      its([:IgnoreFoW]) { is_expected.to be false }
      its([:MeasureMovement]) { is_expected.to be false }
      its([:Autoraise]) { is_expected.to be true }
      its([:Sticky]) { is_expected.to be true }
      its([:Tooltip]) { is_expected.to be true }
      its([:GridProjection]) { is_expected.to be false }
      its([:Hands]) { is_expected.to be true }
      its([:XmlUI]) { is_expected.to be '' }
    end
  end
end
