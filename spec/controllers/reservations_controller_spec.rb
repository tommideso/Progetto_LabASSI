require 'rails_helper'

RSpec.describe ReservationsController, type: :controller do
    let!(:user) { create(:user) }
    let!(:chef) { create(:chef) }
    let!(:client) { create(:client) }
    let!(:menu) { create(:menu) }

    let(:valid_attributes) do
        {
          num_persone: 4,
          tipo_pasto: :pranzo,
          extra: 'vino false mise en place true',
          menu_id: menu.id,
          data_prenotazione: '2024-10-01',
          indirizzo_consegna: 'Via Esempio 123'
        }
      end

     let(:invalid_attributes) do
        {
          num_persone: 'invalid', # valore non valido per num_persone
          tipo_pasto: nil,         # valore non valido per tipo_pasto se non è permesso nil
          extra: 'Vino',
          menu_id: menu.id,
          data_prenotazione: 'invalid-date', # valore non valido per data_prenotazione
          indirizzo_consegna: 'Via Esempio 123'
        }
      end

      before do
        # Autentica l'utente come client
        sign_in client.user
        # Verifica che l'utente sia autenticato
        puts "Current userAAAA: #{controller.current_user.inspect}"
        expect(controller.current_user).to eq(client.user)
        # Verifica che il client sia associato all'utente corretto
        expect(client.user).to be_present
        expect(client.user).to eq(controller.current_user)
      end

  describe 'POST #create' do
  # Testa la creazione di una nuova prenotazione con attributi validi
  it "creates a new Reservation with valid attributes" do
    expect {
      post :create, params: { reservation: valid_attributes }
      puts "Response body: #{response.body}"
      puts "Response status: #{response.status}"
    }.to change(Reservation, :count).by(1)

    reservation = Reservation.last
    puts "Created reservationM: #{reservation.inspect}"
    expect(reservation.client).to eq(client)
    expect(reservation.menu).to eq(menu)
    expect(reservation.chef).to eq(menu.chef)
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

  it 'ensures the reservation chef matches the menu chef' do
    post :create, params: { reservation: valid_attributes }
    reservation = Reservation.last
    expect(reservation.chef).to eq(menu.chef)
  end
end
end
