# frozen_string_literal: true

RSpec.describe Game do
  subject { described_class.new }

  it { is_expected.to be_valid }
end
