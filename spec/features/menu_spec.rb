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

    sleep 3

    # Preme su Crea un nuovo menu
    click_button 'Crea un nuovo menu'

    expect(page).to have_current_path(new_menu_path)
    sleep 1

    # Per il campo rich_text_area
    fill_in 'titolo', with: 'Menu di esempio'
    sleep 1
    # Trova il campo Trix Editor
    find(:css, "#descrizione").click
    # Esegui script JavaScript per impostare il contenuto del campo
    page.execute_script("document.querySelector('#descrizione').editor.setSelectedRange([0, 0]);")
    page.execute_script("document.querySelector('#descrizione').editor.insertString('Descrizione del menu')")
    sleep 1

    # Inserimento piatti (form _dish_form)
    click_button 'Aggiungi un piatto'
    # Seleziona il primo campo di input per il nome del piatto
    all_nome_fields = all(:field, 'nome', visible: true, disabled: false)
    all_nome_fields[0].set('Nome Antipasto')

    # Trova il primo <select> che ha un ID che termina con '_tipo_portata' e seleziona 'Antipasto'
    all_tipo_portata_selects = all(:css, '[id$="_tipo_portata"]')
    select 'Antipasto', from: all_tipo_portata_selects[0][:id]

    # Compila il primo campo degli ingredienti
    all_ingredienti_fields = all(:field, 'ingredienti', visible: true, disabled: false)
    all_ingredienti_fields[0].set('Glutine, lattosio')

    sleep 1

    # Aggiungi il secondo piatto
    click_button 'Aggiungi un piatto'
    # Seleziona il secondo campo di input per il nome del piatto
    all_nome_fields = all(:field, 'nome', visible: true, disabled: false)
    all_nome_fields[1].set('Nome Primo')

    # Trova il secondo <select> che ha un ID che termina con '_tipo_portata' e seleziona 'Primo'
    all_tipo_portata_selects = all(:css, '[id$="_tipo_portata"]')
    select 'Primo', from: all_tipo_portata_selects[1][:id]

    # Compila il secondo campo degli ingredienti
    all_ingredienti_fields = all(:field, 'ingredienti', visible: true, disabled: false)
    all_ingredienti_fields[1].set('Farina, uova')

    sleep 1

    fill_in 'prezzo_persona', with: 10
    sleep 1
    fill_in 'min_persone', with: 2
    fill_in 'max_persone', with: 10
    sleep 1
    select 'Mare', from: 'menu_tipo_cucina'
    sleep 1

    # Compila i campi degli allergeni
    check 'menu_allergeni_glutine'
    check 'menu_allergeni_soia'
    sleep 1

    # Compila i campi delle preferenze alimentari
    check 'menu_preferenze_alimentari_vegano'
    sleep 1

    # Compila i campi di adattabilit
    check 'menu_adattabile_preferenze_vegano'
    fill_in 'menu_extra_misenplace', with: 5
    fill_in 'menu_extra_vino', with: 10
    sleep 1

    # Aggiungi le immagini
    attach_file 'menu_images', Rails.root.join('spec', 'support', 'menu_1.jpg')

    # Clicca sul pulsante per creare il menu
    click_button 'Crea Menu'

    sleep 3

    # Verifica che il menu sia stato creato con successo
    expect(page).to have_content('Menu di esempio')
    expect(page).to have_content('Descrizione del menu')
    expect(page).to have_current_path(menu_path(Menu.last))

    # Modifica il menu
    sleep 2

    click_button 'Modifica'
    fill_in 'titolo', with: 'Menu di pesce'
    sleep 3
    click_button 'Modifica menu'
    sleep 4
  end

  scenario "Creazione menu fallisce perchè non tutti i campi sono stati compilati" do
    # Ridimensiona la finestra del browser
    page.driver.browser.manage.window.resize_to(1920, 1080)

    # Effettua il login
    login_as(chef.user)

    # Visita la pagina del profilo
    visit root_path

    sleep 3

    # Preme su Crea un nuovo menu
    click_button 'Crea un nuovo menu'

    expect(page).to have_current_path(new_menu_path)

    # Clicca sul pulsante per creare il menu
    click_button 'Crea Menu'

    sleep 1

    # Verifica che il menu non sia stato creato
    expect(page).to have_current_path(new_menu_path)
    expect(page).to have_content("Titolo non può essere lasciato in bianco")
    sleep 1
  end
end
