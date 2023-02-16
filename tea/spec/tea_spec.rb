# frozen_string_literal: true

require_relative '../tea'

RSpec.configure do |config|
  config.example_status_persistence_file_path = 'spec/examples.txt'
end

RSpec.describe Tea do
  let(:tea) { Tea.new }

  it 'tastes like Earl Grey' do
    expect(tea.flavor).to eq :earl_grey
  end

  it 'is hot' do
    expect(tea.temperature).to be > 200.0
  end
end
