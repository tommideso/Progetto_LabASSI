require 'rails_helper'

RSpec.describe Reservation, type: :model do
  let(:client) { create(:client) }
  let(:chef) { create(:chef) }
  let(:menu) { create(:menu) }
  let(:reservation) { create(:reservation, client: client, chef: chef, menu: menu) }

  context 'uniqueness validation' do
    # Crea una prenotazione esistente con dati specifici. Questa prenotazione viene usata per verificare la regola di unicità.
    let!(:existing_reservation) { create(:reservation, client: client, chef: chef, data_prenotazione: '2024-09-10', stato: 'confermata', stripe_payment_intent_id: 'pi_123456789') }

    # Crea una nuova prenotazione (non salvata nel database) con lo stesso cliente e data della prenotazione esistente. Verifica che questa prenotazione non sia valida
    it 'does not allow multiple reservations for the same client on the same day' do
      new_reservation = build(:reservation, client: client, chef: chef, data_prenotazione: '2024-09-10')
      expect(new_reservation).to_not be_valid
      expect(new_reservation.errors[:client_id]).to include("Esiste già una prenotazione per il cliente in questa data")
    end

    it 'does not allow multiple reservations for the same chef on the same day' do
      new_reservation = build(:reservation, client: create(:client), chef: chef, data_prenotazione: '2024-09-10')
      expect(new_reservation).to_not be_valid
      expect(new_reservation.errors[:chef_id]).to include("Esiste già una prenotazione per lo chef in questa data")
    end
  end

  #   validates :num_persone, :tipo_pasto, :stato, :data_prenotazione, :indirizzo_consegna, :extra, presence: true
  it "is not valid without num_persone" do
    reservation = Reservation.new(num_persone: nil, tipo_pasto: "pranzo", stato: "confermata", data_prenotazione: Date.today, indirizzo_consegna: "via roma 1", extra: "extra")
    expect(reservation).to_not be_valid
  end

  it "is not valid without tipo_pasto" do
    reservation = Reservation.new(num_persone: 2, tipo_pasto: nil, stato: "confermata", data_prenotazione: Date.today, indirizzo_consegna: "via roma 1", extra: "extra")
    expect(reservation).to_not be_valid
  end

  it "is not valid without stato" do
    reservation = Reservation.new(num_persone: 2, tipo_pasto: "pranzo", stato: nil, data_prenotazione: Date.today, indirizzo_consegna: "via roma 1", extra: "extra")
    expect(reservation).to_not be_valid
  end

  it "is not valid without data_prenotazione" do
    reservation = Reservation.new(num_persone: 2, tipo_pasto: "pranzo", stato: "confermata", data_prenotazione: nil, indirizzo_consegna: "via roma 1", extra: "extra")
    expect(reservation).to_not be_valid
  end

  it "is not valid without indirizzo_consegna" do
    reservation = Reservation.new(num_persone: 2, tipo_pasto: "pranzo", stato: "confermata", data_prenotazione: Date.today, indirizzo_consegna: nil, extra: "extra")
    expect(reservation).to_not be_valid
  end

  it "is not valid without extra" do
    reservation = Reservation.new(num_persone: 2, tipo_pasto: "pranzo", stato: "confermata", data_prenotazione: Date.today, indirizzo_consegna: "via roma 1", extra: nil)
    expect(reservation).to_not be_valid
  end

  it 'has a valid factory' do
    reservation = FactoryBot.create(:reservation)
    expect(reservation).to be_valid
  end
end
