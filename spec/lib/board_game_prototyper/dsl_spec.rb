# frozen_string_literal: true

RSpec.describe BoardGamePrototyper::Dsl do
  context :game do 
    it 'has a game keyword' do
      expect(public_method :game).to be_truthy
    end

    it 'set the game instance' do
      game_obj = game do
        name 'Foo'
      end
      expect(game_obj.name).to eq('Foo')
    end
  end
end
