# frozen_string_literal: true

require_relative '../coffee'

RSpec.describe 'A cup of coffee' do
  let(:coffee) { Coffee.new }

  it 'costs $1' do
    expect(coffee.price).to eq(1.0)
  end

  context 'with milk' do
    before { coffee.add :milk }

    it 'costs $1.25' do
      expect(coffee.price).to eq(1.25)
    end
  end
end
