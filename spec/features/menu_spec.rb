require 'rails_helper'

RSpec.feature "Menu", type: :feature, js: true do
  let(:chef) { create(:chef) }
  
  scenario "Chef crea un menu con successo" do
    # Ridimensiona la finestra del browser
    page.driver.browser.manage.window.resize_to(1920, 1080)

    # Effettua il login
    login_as(chef.user)

    # Visita la pagina del profilo
    visit root_path

    #Preme su Crea un nuovo menu
    click_button 'Crea un nuovo menu'

    expect(page).to have_current_path(new_menu_path)

    fill_in 'titolo', with: 'Menu di esempio'
    # Trova il campo Trix Editor
    find(:css, "#descrizione").click
    # Esegui script JavaScript per impostare il contenuto del campo
    page.execute_script("document.querySelector('#descrizione').editor.setSelectedRange([0, 0]);")
    page.execute_script("document.querySelector('#descrizione').editor.insertString('Descrizione del menu')")

    #Inserimento piatti (nel form _dish_form)

    click_button 'Aggiungi piatto'
    # Seleziona il primo campo di input per il nome del piatto
    all_nome_fields = all(:field, 'nome', visible: true, disabled: false)
    all_nome_fields[0].set('Nome Antipasto')

    # Trova il primo <select> che ha un ID che termina con '_tipo_portata' e seleziona 'Antipasto'
    all_tipo_portata_selects = all(:css, '[id$="_tipo_portata"]')
    select 'Antipasto', from: all_tipo_portata_selects[0][:id]

    # Compila il primo campo degli ingredienti
    all_ingredienti_fields = all(:field, 'ingredienti', visible: true, disabled: false)
    all_ingredienti_fields[0].set('Glutine, lattosio')

    # Aggiungi il secondo piatto
    click_button 'Aggiungi piatto'
    # Seleziona il secondo campo di input per il nome del piatto
    all_nome_fields = all(:field, 'nome', visible: true, disabled: false)
    all_nome_fields[1].set('Nome Primo')

    # Trova il secondo <select> che ha un ID che termina con '_tipo_portata' e seleziona 'Primo'
    all_tipo_portata_selects = all(:css, '[id$="_tipo_portata"]')
    select 'Primo', from: all_tipo_portata_selects[1][:id]

    # Compila il secondo campo degli ingredienti
    all_ingredienti_fields = all(:field, 'ingredienti', visible: true, disabled: false)
    all_ingredienti_fields[1].set('Farina, uova')


    fill_in 'prezzo_persona', with: 10
    fill_in 'min_persone', with: 2
    fill_in 'max_persone', with: 10

    select 'Mare', from: 'menu_tipo_cucina'

    # Compila i campi degli allergeni
    check 'soia'
    check 'noci'
 
    # Compila i campi delle preferenze alimentari
    check 'vegano'

    # Compila i campi di adattabilit
    check 'menu_adattabile_preferenze_vegano'
    fill_in 'menu_extra_misenplace', with: 5
    fill_in 'menu_extra_vino', with: 10

    # Aggiungi le immagini
    attach_file 'menu_images', Rails.root.join('spec', 'support', 'menu_1.jpg')

    # Clicca sul pulsante per creare il menu
    click_button 'Crea Menu'

    sleep 3

    # Verifica che il menu sia stato creato con successo
    expect(page).to have_content('Menu di esempio')
    expect(page).to have_content('Descrizione del menu')
    expect(page).to have_current_path(menu_path(Menu.last))
    sleep 3

  end

  scenario "Creazione menu fallisce perchè non tutti i campi sono stati compilati" do
    # Ridimensiona la finestra del browser
    page.driver.browser.manage.window.resize_to(1920, 1080)

    # Effettua il login
    login_as(chef.user)

    # Visita la pagina del profilo
    visit root_path

    #Preme su Crea un nuovo menu
    click_button 'Crea un nuovo menu'

    expect(page).to have_current_path(new_menu_path)

    # Clicca sul pulsante per creare il menu
    click_button 'Crea Menu'

    sleep 3

    # Verifica che il menu non sia stato creato
    expect(page).to have_current_path(new_menu_path)
    expect(page).to have_content("Titolo non può essere")

    sleep 3

  end

end
