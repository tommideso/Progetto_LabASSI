require 'rails_helper'

RSpec.describe ReservationsController, type: :controller do
    let!(:user) { create(:user) }
    let!(:chef) { create(:chef) }
    let!(:client) { create(:client) }
    let!(:menu) { create(:menu) }

    let(:valid_attributes) do
        {
          client_id: client.id,
          chef_id: chef.id,
          num_persone: 4,
          tipo_pasto: :pranzo,
          extra: 'vino false mise en place true',
          menu_id: menu.id,
          data_prenotazione: '2024-10-01',
          indirizzo_consegna: 'Via Esempio 123',
          prezzo: 100.0
        }
      end
      
     let(:invalid_attributes) do
        {
          client_id: client.id,
          chef_id: chef.id,
          num_persone: 'invalid', # valore non valido per num_persone
          tipo_pasto: nil,         # valore non valido per tipo_pasto se non è permesso nil
          extra: 'Vino',
          menu_id: 3,
          data_prenotazione: 'invalid-date', # valore non valido per data_prenotazione
          indirizzo_consegna: 'Via Esempio 123',
          prezzo: 'invalid'       # valore non valido per prezzo
        }
      end

  before do
    sign_in user # Esegui il login dell'utente per i test
  end

  describe 'POST #create' do
  # Testa la creazione di una nuova prenotazione con attributi validi
  it 'creates a new reservation with valid attributes' do
    expect {
      post :create, params: { reservation: valid_attributes }
    }.to change(Reservation, :count).by(1)

    reservation = Reservation.last
    expect(reservation.client).to eq(client)
    expect(reservation.chef).to eq(chef)
  end

  it 'does not create a new reservation with invalid attributes' do
    expect {
      post :create, params: { reservation: invalid_attributes }
    }.not_to change(Reservation, :count)
  end 

  it 'redirects to the reservation page after creation' do
    post :create, params: { reservation: valid_attributes }
    expect(response).to redirect_to(Reservation.last)
   
  end
end


end

