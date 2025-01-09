# frozen_string_literal: true

RSpec.describe Book do
  include FakeFS::SpecHelpers
  context 'with only game' do
    subject { described_class.new(game: game { name 'Book Spec Only Game' }) }

    it { is_expected.not_to be_valid }
  end

  context 'with minimum fields' do
    subject(:book) do
      described_class.new(game: Game.new)
    end

    it { is_expected.to be_valid }
  end
end
