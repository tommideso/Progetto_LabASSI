require 'rails_helper'

RSpec.describe Menu, type: :model do
  it 'has a valid factory' do
    menu = FactoryBot.create(:menu)
    expect(menu).to be_valid
    expect(menu.dishes.count).to eq(1)
  end
end