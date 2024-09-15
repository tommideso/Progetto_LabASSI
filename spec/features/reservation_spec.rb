require 'rails_helper'

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
    sleep 1

     # Compila i campi di prenotazione utilizzando gli attributi `id`
     fill_in 'indirizzo_consegna', with: 'Via Esempio 123'
     sleep 1
     fill_in 'num_persone', with: menu.min_persone
     sleep 1
     select 'Pranzo', from: 'reservation_tipo_pasto'

     # Uso jQuery per selezionare una data
     page.execute_script("document.querySelector('#data_prenotazione').value = '2024-10-01'")

     # Seleziona la checkbox per il vino se è presente nel menu
     if page.has_field?('vino', type: 'checkbox')
       check 'vino' # Usa il nome della checkbox o il suo ID per selezionarla
        puts "Vino selezionato"
     end

     # Seleziona la checkbox per il mise en place se è presente nel menu
     if page.has_field?('miseenplace', type: 'checkbox')
       check 'miseenplace' # Usa il nome della checkbox o il suo ID per selezionarla
     end

     fill_in 'modifiche_richieste', with: '1 senza glutine, 1 senza lattosio'

    # Clicca sul pulsante per effettuare la prenotazione
    click_button 'Prenota'
    sleep 1

    # Verifica che la prenotazione sia stata creata con successo
    expect(page).to have_content('Prenotazione')
    expect(page).to have_content('Via Esempio 123')
    expect(page).to have_content(menu.min_persone)
    expect(page).to have_content('Pranzo')
    expect(page).to have_content('2024-10-01')

    sleep 1
    expect(page).to have_current_path(reservation_path(Reservation.last))
  end

  scenario "Prenotazione fallisce perche non tutti i campi sono stati compilati" do
    # Ridimensiona la finestra del browser
    page.driver.browser.manage.window.resize_to(1920, 1080)

    # Effettua il login
    login_as(client.user)

    # Visita la pagina del menu
    visit menu_path(menu)

    # Non compila l'indirizzo di consegna
    fill_in 'indirizzo_consegna', with: ''
    fill_in 'num_persone', with: menu.min_persone
    select 'Pranzo', from: 'reservation_tipo_pasto'
    page.execute_script("document.querySelector('#data_prenotazione').value = '2024-10-01'")
    sleep 2

    # Clicca sul pulsante per effettuare la prenotazione
    click_button 'Prenota'
    sleep 3

    # mi aspetto di rimanere sulla stessa pagina
    expect(page).to have_current_path(menu_path(menu))
    expect(page).to have_content("Impossibile creare la prenotazione")
  end

  scenario "Utente non loggato non riesce a prenotare" do
    # Utente preme il pulsante del logout
    visit menu_path(menu)
    sleep 3
    # Non deve esserci il bottone prenota
    expect(page).not_to have_button('Prenota')
  end
end
