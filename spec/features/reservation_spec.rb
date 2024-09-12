require 'rails_helper'


# TODO intanto lo pusho cosi
RSpec.feature "Reservation", type: :feature, js: true do
  let(:client) { create(:client) }
  let(:chef) { create(:chef) }
  let(:menu) { create(:menu) }


  scenario "Cliente prenota un menu con successo" do
    # Ridimensiona la finestra del browser
    page.driver.browser.manage.window.resize_to(1920, 1080)

    # Effettua il login
    login_as(client.user)

    # Visita la pagina del menu
    visit menu_path(menu)

    expect(page).to have_css("turbo-stream[action='replace'][target='reservation-list']")


    # Stampa il contenuto della pagina per il debug
    puts("AAAAAAAAAAAAAAAAAAAAAAAA")
    expect(page).to have_selector("select#reservation_tipo_pasto")

    puts page.body

    # Compila i campi di prenotazione utilizzando gli attributi `id`

    fill_in 'indirizzo_consegna', with: 'Via Esempio 123'
    fill_in 'num_persone', with: '4'
    select 'Pranzo', from: 'reservation_tipo_pasto'


    # fill_in 'data_prenotazione', with: '2024-10-01'
    #  check 'vino' if @menu.extra["vino"] > 0
    #  check 'miseenplace' if @menu.extra["miseenplace"] > 0
  end
end


#  # Clicca sul pulsante per effettuare la prenotazione
#  click_button 'Prenota'

#  # Verifica che la prenotazione sia stata creata con successo
#  expect(page).to have_content('Prenotazione creata con successo')
#  expect(page).to have_content('Via Esempio 123')
#  expect(page).to have_content('4')
#  expect(page).to have_content('Pranzo')
#  expect(page).to have_content('2024-10-01')

# # Verifica che la pagina di conferma della prenotazione sia visualizzata
# expect(page).to have_current_path(reservation_path(Reservation.last))
# expect(page).to have_content('Prenotazione creata con successo')
# expect(Reservation.last.stato).to eq('attesa_pagamento')

# # Verifica che la prenotazione sia visibile nella pagina dell'utente
# visit user_profile_path(user)
# expect(page).to have_content('2024-10-01')
# expect(page).to have_content('Pranzo')
# expect(page).to have_content('4')
