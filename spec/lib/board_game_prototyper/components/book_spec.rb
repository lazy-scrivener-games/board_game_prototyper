# frozen_string_literal: true

RSpec.describe Book do
  include FakeFS::SpecHelpers
  context 'with only game' do
    subject { described_class.new(game: game { name 'Book Spec Only Game' }) }

    it { is_expected.not_to be_valid }
  end

  context 'with minimum fields' do
    subject(:book) do
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
    its(:locked) { is_expected.to be_nil }
    its(:disabled) { is_expected.to be_nil }
    its(:inspect) { is_expected.to eq 'Book: , components: 0' }
  end

  context 'with all fields' do
    subject(:book) do
      require_relative '../configs/components/book/full'
      book_subject
    end

    after do
      Component.send(:remove_const, :BookSpecBookName)
    end

    it { is_expected.to be_valid }
    its(:tts_name) { is_expected.to be 'Book Spec Book TTS' }
    its(:name) { is_expected.to be 'Book Spec Book Name' }
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
    its(:book) { is_expected.to be_nil }
    its(:locked) { is_expected.to be true }
    its(:disabled) { is_expected.to be_nil }
    specify { expect(book.to_s).to eq 'Book: Book Spec Book Name, components: 5' }
    its(:inspect) { is_expected.to eq 'Book: Book Spec Book Name, components: 5' }
    its(:type) { is_expected.to eq 'component/book_spec_book_name' }
  end
end
