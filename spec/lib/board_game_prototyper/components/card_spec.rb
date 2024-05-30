# frozen_string_literal: true

require_relative '../configs/components/deck/minimal'
# Have it here once instead of in a subject or let so it's not being re-defined every time
deck = deck_subject

RSpec.describe Card do
  # include FakeFS::SpecHelpers
  context 'with only game and collection' do
    subject(:card) do
      deck.cards.first
    end

    it { is_expected.to be_valid }
    its(:tts_name) { is_expected.to be 'Card' }
    its(:name) { is_expected.to eq 'test card' }
    its(:x) { is_expected.to be 3 }
    its(:rot_x) { is_expected.to be 0 }
    its(:y) { is_expected.to be 0 }
    its(:rot_y) { is_expected.to be 180 }
    its(:z) { is_expected.to be 0 }
    its(:rot_z) { is_expected.to be 180 }
    its(:images) { is_expected.to be true }
    its(:guid) { is_expected.to eq 'card0' }
    its(:guids) { is_expected.to eq ['card0'] }
    its(:hands) { is_expected.to be true }
    its(:id) { is_expected.to eq '100' }
    its(:game) { is_expected.to be_a(Game) }
    its(:front) { is_expected.to eq 'standard_card' }
    its(:back) { is_expected.to eq 'back' }
    its(:view_name) { is_expected.to eq '_card' }
    its(:r) { is_expected.to eq 0.71 }
    its(:b) { is_expected.to eq 0.71 }
    its(:g) { is_expected.to eq 0.71 }
    its(:scale_x) { is_expected.to eq 1.0 }
    its(:scale_y) { is_expected.to eq 1.0 }
    its(:scale_z) { is_expected.to eq 1.0 }
    specify { expect(card.collection.to_s).to eq 'Deck: Deck Spec Deck Name Minimal, components: 5' }
    its(:collection) { is_expected.to be deck }
    its(:deck) { is_expected.to be deck }
    its(:locked) { is_expected.to be_nil }
    its(:disabled) { is_expected.to be_nil }
    its(:to_s) { is_expected.to eq 'Card::DeckSpecDeckNameMinimal: test card' }
    its(:inspect) { is_expected.to eq 'Card::DeckSpecDeckNameMinimal: test card' }

    its(:width) { is_expected.to eq 500 }
    its(:height) { is_expected.to eq 700 }

    context 'when creating images' do
      before { FileUtils.rm_rf('spec/fixtures/output') }

      it 'creates a back image with the correct path' do
        card.create_back
        target = card.image_path('back')
        expect(target).to eq 'spec/fixtures/output/images/card/deck_spec_deck_name_minimal/test_card_back-card0.png'
      end

      it 'creates a back image that matches the saved version' do
        card.create_back
        target = card.image_path('back')
        saved_md5 = Digest::MD5.file(
          'spec/fixtures/saved-output/images/card/deck_spec_deck_name_minimal/test_card_back-card0.png'
        ).hexdigest
        expect(Digest::MD5.file(target).hexdigest).to eq saved_md5
      end

      # create_images - test this in collection
      # create_back
    end
    # tts_config
  end

  context 'with all fields' do
    subject(:card) do
      game = Game.new(config_path: 'spec/fixtures', name: 'Card Spec game and collection only')
      # TODO: Actually put all fields in
      described_class.new(game:, collection: Collection.new(game:), tts_name: 'tts_name', x: 0, rot_x: 0,
                          y: 0, rot_y: 0, z: 0, rot_z: 0)
    end

    it { is_expected.to be_valid }
  end
end
