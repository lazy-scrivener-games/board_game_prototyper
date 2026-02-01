# frozen_string_literal: true

RSpec.describe Rollable do
  subject(:source) { described_class.new(source_target) }

  let(:source_target) { true }

  it 'responds to length' do
    expect(source.respond_to?(:nil?)).to be true
  end

  it 'does not respond to gibberish' do
    expect(source.respond_to?(:gibberish)).to be false
  end

  context 'when source is a hash' do
    let(:source_target) { { first: 1, second: 2, third: 'three' } }

    its(:to_s) { is_expected.to eq '{:first=>1, :second=>2, :third=>"three"}' }
    its(:length) { is_expected.to eq 3 }

    context 'with helper methods' do
      it 'multiplies' do
        expect(source.multiply(3)).to eq({ first: 3, second: 6, third: 'threethreethree' })
      end

      it 'appends' do
        expect(source.append(' - ending')).to eq('{:first=>1, :second=>2, :third=>"three"} - ending')
      end
    end
  end

  context 'when source is an array' do
    let(:source_target) { [1, 2, 'three'] }

    its(:to_s) { is_expected.to eq '[1, 2, "three"]' }
    its(:length) { is_expected.to eq 3 }

    context 'with helper methods' do
      it 'multiplies' do
        expect(source.multiply(3)).to eq([3, 6, 'threethreethree'])
      end

      it 'appends' do
        expect(source.append(' - ending')).to eq('[1, 2, "three"] - ending')
      end
    end
  end

  context 'when source is an integer' do
    let(:source_target) { 'amaze' }

    its(:to_s) { is_expected.to eq 'amaze' }
    its(:length) { is_expected.to eq 5 }

    context 'with helper methods' do
      it 'multiplies' do
        expect(source.multiply(3)).to eq('amazeamazeamaze')
      end

      it 'appends' do
        expect(source.append(' - ending')).to eq('amaze - ending')
      end
    end
  end
end
