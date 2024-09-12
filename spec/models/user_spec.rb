require 'rails_helper'

RSpec.describe User, type: :model do
  # Test per la presenza di email e password, dato che Devise gestisce queste validazioni

  it "is not valid without an email" do
    user = User.new(email: nil, password: "password123")
    expect(user).to_not be_valid
  end

  it "is not valid without a password" do
    user = User.new(email: "user@example.com", password: nil)
    expect(user).to_not be_valid
  end

  it "is valid with an email and password" do
    user = User.new(email: "user@example.com", password: "password123")
    expect(user).to be_valid
  end

  # Test per admin
  context "quando viene creato un admin" do
    it "ha tutti gli attributi corretti" do
      admin = create(:admin)

      expect(admin).to be_valid  # Verifica che l'admin sia valido
      expect(admin.email).to eq("admin@admin.it")  # Verifica l'email
      expect(admin.nome).to eq("Admin")  # Verifica il nome
      expect(admin.cognome).to eq("Admin")  # Verifica il cognome
      expect(admin.ruolo).to eq("admin")  # Verifica che il ruolo sia 'admin'
      expect(admin.completed).to eq(2)  # Verifica che 'completed' sia 2
      expect(admin.confirmed_at).to_not be_nil  # Verifica che sia confermato
    end
  end
end
