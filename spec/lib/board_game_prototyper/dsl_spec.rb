# frozen_string_literal: true

RSpec.describe BoardGamePrototyper::Dsl do
  context :game do 
    it 'has a game keyword' do
      expect(public_method :game).to be_truthy
    end

    it 'set the game instance' do
      game do
        name 'Foo'
      end
      expect(GAME.name).to eq('Foo')
    end
  end

  context :component do
    subject { :component }
    specify { expect(public_method subject).to be_truthy }

  end
end
