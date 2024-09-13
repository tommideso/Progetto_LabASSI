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

    # Compila i campi di prenotazione utilizzando gli attributi `id`
     fill_in 'indirizzo_consegna', with: 'Via Esempio 123'
     fill_in 'num_persone', with: menu.min_persone
     select 'Pranzo', from: 'reservation_tipo_pasto'
     #TODO non lo preme
    #  page.execute_script("document.querySelector('#data_prenotazione').datepicker('setDate', '01/01/2010')")
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

     # Aspetta 3 secondi
      sleep 1

    # Clicca sul pulsante per effettuare la prenotazione
    click_button 'Prenota'
    sleep 3

    # Verifica che la prenotazione sia stata creata con successo
    expect(page).to have_content('Reservation Details')     
    expect(page).to have_content('Via Esempio 123')
    expect(page).to have_content(menu.min_persone)
    expect(page).to have_content('pranzo')
    expect(page).to have_content('2024-10-01')
   
    sleep 2
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

    # Aspetta 3 secondi
    sleep 1

    # Clicca sul pulsante per effettuare la prenotazione
    click_button 'Prenota'
    sleep 3

    # mi aspetto di rimanere sulla stessa pagina
    expect(page).to have_current_path(menu_path(menu))
    expect(page).to have_content("Impossibile creare la prenotazione")
  end


end





    
