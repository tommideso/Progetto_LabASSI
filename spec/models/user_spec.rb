require 'rails_helper'

RSpec.describe User, type: :model do
  # Test per la presenza di email e password, dato che Devise gestisce queste validazioni

  it "is not valid without an email" do
    user = User.new(email: nil, password: "password123")
    expect(user).to_not be_valid
    expect(user.errors[:email]).to include("can't be blank")
  end

  it "is not valid without a password" do
    user = User.new(email: "user@example.com", password: nil)
    expect(user).to_not be_valid
    expect(user.errors[:password]).to include("can't be blank")
  end

  it "is valid with an email and password" do
    user = User.new(email: "user@example.com", password: "password123")
    expect(user).to be_valid
  end

end
