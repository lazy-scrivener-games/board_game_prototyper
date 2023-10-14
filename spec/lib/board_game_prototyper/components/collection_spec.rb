# frozen_string_literal: true

RSpec.describe Collection do
  include FakeFS::SpecHelpers
  context 'with only game' do
    subject { described_class.new(game: game { name 'Collection Spec Only Game' }) }

    it { is_expected.not_to be_valid }
  end

  context 'with minimum fields' do
    subject(:collection) do
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
    specify { expect(collection.to_s).to eq 'Collection: , components: 0' }
    its(:inspect) { is_expected.to eq 'Collection: , components: 0' }

    it 'cannot get an image path without a name' do
      expect do
        collection.image_path('ending')
      end.to raise_error(NoMethodError, "undefined method `gsub' for nil:NilClass")
    end

    context 'the tts_config' do
      subject(:tts_config) { collection.tts_config }

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
    subject(:collection) do
      require_relative '../configs/components/collection/full'
      collection_subject
    end

    after do
      Component.send(:remove_const, :CollectionSpecCollectionName)
    end

    it { is_expected.to be_valid }
    its(:tts_name) { is_expected.to be 'Collection Spec Collection TTS' }
    its(:name) { is_expected.to be 'Collection Spec Collection Name' }
    its(:x) { is_expected.to be 1 }
    its(:rot_x) { is_expected.to be 2 }
    its(:y) { is_expected.to be 3 }
    its(:rot_y) { is_expected.to be 4 }
    its(:z) { is_expected.to be 5 }
    its(:rot_z) { is_expected.to be 6 }
    its(:images) { is_expected.to be true }
    its(:guid) { is_expected.to be 'guid' }
    its(:guids) { is_expected.to eq %w[comp0 comp1 comp2 comp3 comp4 guid] }
    its(:hands) { is_expected.to be false }
    its(:id) { is_expected.to eq 99 }
    its(:game) { is_expected.to be_a(Game) }
    its(:view_name) { is_expected.to be 'view_name' }
    its(:r) { is_expected.to eq 7 }
    its(:g) { is_expected.to eq 8 }
    its(:b) { is_expected.to eq 9 }
    its(:scale_x) { is_expected.to eq 10 }
    its(:scale_y) { is_expected.to eq 11 }
    its(:scale_z) { is_expected.to eq 12 }
    its(:collection) { is_expected.to be_nil }
    its(:locked) { is_expected.to be true }
    its(:disabled) { is_expected.to be_nil }
    specify { expect(collection.to_s).to eq 'Collection: Collection Spec Collection Name, components: 5' }
    its(:inspect) { is_expected.to eq 'Collection: Collection Spec Collection Name, components: 5' }
    its(:type) { is_expected.to eq 'component/collection_spec_collection_name' }

    its(:recursive_attributes) do # rubocop:disable RSpec/ExampleLength
      is_expected.to eq({
                          'b' => 9,
                          'component_base_class' => Component,
                          'component_class' => {
                            'dynamic_attributes' => {
                              # rubocop:disable  Layout/LineLength
                              'cost_display' => [
                                '/home/elim/code/board_game_prototyper/spec/lib/board_game_prototyper/configs/components/collection/full.rb', 41
                              ],
                              'doubled_integers' => [
                                '/home/elim/code/board_game_prototyper/spec/lib/board_game_prototyper/configs/components/collection/full.rb', 47
                              ],
                              'guid' => [
                                '/home/elim/code/board_game_prototyper/spec/lib/board_game_prototyper/configs/components/collection/full.rb', 33
                              ],
                              'power_split' => [
                                '/home/elim/code/board_game_prototyper/spec/lib/board_game_prototyper/configs/components/collection/full.rb', 44
                              ]
                              # rubocop:enable  Layout/LineLength
                            },
                            'tags' => { 'tag1' => ['cost'] }
                          },
                          'component_type' => 'component',
                          'components' => collection.components,
                          'g' => 8,
                          'game' => { 'config_path' => '/config/path', 'next_component_id' => 1,
                                      'output_path' => '/output/path', 'name' => 'Collection Spec Game',
                                      'new_save' => 'new_save', 'validation_context' => nil },
                          'guid' => 'guid',
                          'hands' => false,
                          'id' => 99,
                          'images' => true,
                          'locked' => true,
                          'name' => 'Collection Spec Collection Name',
                          'r' => 7,
                          'rot_x' => 2,
                          'rot_y' => 4,
                          'rot_z' => 6,
                          'scale_x' => 10,
                          'scale_y' => 11,
                          'scale_z' => 12,
                          'stats' => { 'cost' => { 'max' => 5 }, 'power.length' => { 'average' => 12.0, 'min' => 12 } },
                          'tts_name' => 'Collection Spec Collection TTS',
                          'validation_context' => nil,
                          'view_name' => 'view_name',
                          'x' => 1,
                          'y' => 3,
                          'z' => 5
                        })
    end

    it 'generates a single stat' do
      expect(collection.stats[:cost]).to eq({ 'max' => 5 })
    end

    it 'generates a stat using a property of a value' do
      expect(collection.stats['power.length']).to eq({ 'average' => 12.0, 'min' => 12 })
    end

    it 'generates an image path successfully' do
      expect(collection.image_path('ending')).to eq(
        '/config/path/output/images/collection/collection_spec_collection_name_ending-guid.png'
      )
    end

    it 'generates an image path successfully from output path' do
      expect(
        collection.image_path('ending', config: true)
      ).to eq(
        '/output/path/images/collection/collection_spec_collection_name_ending-guid.png'
      )
    end

    context 'the tts_config' do
      subject(:tts_config) { collection.tts_config }

      its([:GUID]) { is_expected.to be 'guid' }
      its([:Name]) { is_expected.to be 'Collection Spec Collection TTS' }
      its(%i[Transform posX]) { is_expected.to be 1 }
      its(%i[Transform posY]) { is_expected.to be 3 }
      its(%i[Transform posZ]) { is_expected.to be 5 }
      its(%i[Transform rotX]) { is_expected.to be 2 }
      its(%i[Transform rotY]) { is_expected.to be 4 }
      its(%i[Transform rotZ]) { is_expected.to be 6 }
      its(%i[Transform scaleX]) { is_expected.to be 10 }
      its(%i[Transform scaleY]) { is_expected.to be 11 }
      its(%i[Transform scaleZ]) { is_expected.to be 12 }
      its([:Nickname]) { is_expected.to be 'Collection Spec Collection Name' }
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
      its([:Hands]) { is_expected.to be false }
      its([:XmlUI]) { is_expected.to be '' }
    end

    context 'the first component' do
      subject(:first_component) { collection.components.first }

      its(:cost) { is_expected.to be 5 }
      its(:cost_display) { is_expected.to eq '5 thingies' }
      its(:power_split) { is_expected.to eq %w[ov rwh lming] }
      its(:doubled_integers) { is_expected.to eq({ 'cost' => 10 }) }
    end
  end
end
