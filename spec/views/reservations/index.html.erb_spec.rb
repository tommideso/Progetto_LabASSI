require 'rails_helper'

RSpec.describe "reservations/index.html.erb", type: :view do
  let(:client) { create(:client) }
  let(:chef) { create(:chef) }
  let(:menu) { create(:menu) }
  let(:reservation1) { create(:reservation, client: client, chef: chef, menu: menu, data_prenotazione: '2024-09-10') }
  let(:reservation2) { create(:reservation, client: client, chef: chef, menu: menu, data_prenotazione: '2024-10-10') }
  let(:admin) { create(:admin) }  # Creiamo un utente admin

  context "quando non ci sono prenotazioni" do
    it "mostra il messaggio 'Non hai prenotazioni'" do
      assign(:reservations, [])
      allow(view).to receive(:current_user).and_return(client.user)

      render

      expect(rendered).to match /Non hai prenotazioni/
    end
  end

  context "quando ci sono prenotazioni per un utente non admin" do
    it "mostra il titolo 'Le tue prenotazioni' e le prenotazioni" do
      assign(:reservations, [reservation1, reservation2])
      allow(view).to receive(:current_user).and_return(client.user)

      render

      expect(rendered).to match /Le tue prenotazioni/
      expect(rendered).to match /4 persone, Pranzo il 2024-09-10/
      expect(rendered).to match /4 persone, Pranzo il 2024-10-10/
    end
  end

  context "quando l'utente è un admin" do
    it "mostra il titolo 'Tutte le prenotazioni' e le prenotazioni" do
      assign(:reservations, [reservation1, reservation2])
      allow(view).to receive(:current_user).and_return(admin)

      render

      expect(rendered).to match /Tutte le prenotazioni/
      expect(rendered).to match /4 persone, Pranzo il 2024-09-10/
      expect(rendered).to match /4 persone, Pranzo il 2024-10-10/
    end
  end

  context "verifica che il parziale '_reservation_card' venga reso correttamente" do
    it "renderizza il parziale per ogni prenotazione" do
      assign(:reservations, [reservation1, reservation2])
      allow(view).to receive(:current_user).and_return(client.user)

      render

      expect(view).to render_template(partial: '_reservation_card', count: 2)
    end
  end
end