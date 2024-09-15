## Seeds
require 'open-uri'

# Create a user for the admin
admin_email = "admin@admin.it"
admin = User.create!(
    email: admin_email,
    nome: "Admin",
    cognome: "Admin",
    ruolo: "admin",
    password: admin_email,
    encrypted_password: User.new(password: admin_email).encrypted_password,
    confirmed_at: Time.now,
    completed: 2,
)
puts "Created admin user #{admin.inspect}"

# Creazione dell'utente chef con email: chef@chef.it e password: chef@chef.it
user = User.create!(
  email: "chef@chef.it",
  nome: "Chef",
  cognome: "Chef",
  ruolo: "chef",
  password: "chef@chef.it",
  confirmed_at: Time.now,
  completed: 2,
)

Chef.create!(
  user: user,
  telefono: Faker::PhoneNumber.cell_phone_in_e164.to_s,
  indirizzo: Faker::Address.full_address,
  raggio: Faker::Number.between(from: 5, to: 50),
  descrizione: Faker::Restaurant.description,
)

# Creazione del client con email: client@client e password: client@client
user = User.create!(
  email: "client@client.it",
  nome: "Client",
  cognome: "Client",
  ruolo: "client",
  password: "client@client.it",
  confirmed_at: Time.now,
  completed: 2,
)
Client.create!(
  user: user,
  telefono: Faker::PhoneNumber.cell_phone_in_e164.to_s,
  indirizzo: Faker::Address.full_address,
  allergeni: { "glutine" => Faker::Boolean.boolean, "soia" => Faker::Boolean.boolean, "noci" => Faker::Boolean.boolean, "lattosio" => Faker::Boolean.boolean, "crostacei" => Faker::Boolean.boolean, "arachidi" => Faker::Boolean.boolean },
)


## Create some users
password = "password"

15.times do |i|
    # Create a user
    u = User.create!(
        email: Faker::Internet.email,
        nome: Faker::Name.first_name,
        cognome: Faker::Name.last_name,
        ruolo: i < 11 ? 'chef' : 'client', # Alterna tra chef e client,
        password: password,
        encrypted_password: User.new(password: password).encrypted_password,
        confirmed_at: Time.now,
        completed: 2,
    )
    puts "Created user #{i}"

    if u.chef?
        c = Chef.create!(
            user: u,
            telefono: Faker::PhoneNumber.cell_phone_in_e164.to_s,
            indirizzo: Faker::Address.full_address,
            raggio: Faker::Number.between(from: 5, to: 50),
            descrizione: Faker::Restaurant.description,
        )
        puts "Created chef #{i}, chef: #{c.inspect}"
    else
        c = Client.create!(
            user: u,
            telefono: Faker::PhoneNumber.cell_phone_in_e164.to_s,
            indirizzo: Faker::Address.full_address,
            allergeni: { "glutine" => Faker::Boolean.boolean, "soia" => Faker::Boolean.boolean, "noci" => Faker::Boolean.boolean, "lattosio" => Faker::Boolean.boolean, "crostacei" => Faker::Boolean.boolean, "arachidi" => Faker::Boolean.boolean },

        )
        puts "Created client #{i}, client: #{c.inspect}"
    end
end



30.times.with_index do |i|
    ActiveRecord::Base.transaction do
      menu = Menu.find_or_initialize_by(titolo: Faker::Food.dish)
      menu.assign_attributes(
        descrizione: Faker::Food.description,
        prezzo_persona: Faker::Number.decimal(l_digits: 2, r_digits: 2),
        min_persone: Faker::Number.between(from: 2, to: 10),
        max_persone: Faker::Number.between(from: 11, to: 20),
        tipo_cucina: Faker::Food.dish,
        allergeni: {
          "glutine" => Faker::Boolean.boolean,
          "soia" => Faker::Boolean.boolean,
          "noci" => Faker::Boolean.boolean,
          "lattosio" => Faker::Boolean.boolean,
          "crostacei" => Faker::Boolean.boolean,
          "arachidi" => Faker::Boolean.boolean
        },
        preferenze_alimentari: {
          "vegano" => Faker::Boolean.boolean,
          "glutine" => Faker::Boolean.boolean
        },
        adattabile: {
          "preferenze" => {
            "vegano" => Faker::Boolean.boolean,
            "glutine" => Faker::Boolean.boolean
          },
          "allergeni" => {
            "glutine" => Faker::Boolean.boolean,
            "soia" => Faker::Boolean.boolean,
            "noci" => Faker::Boolean.boolean,
            "lattosio" => Faker::Boolean.boolean,
            "crostacei" => Faker::Boolean.boolean,
            "arachidi" => Faker::Boolean.boolean
          }
        },
        extra: {
          "miseenplace" => Faker::Boolean.boolean ? Faker::Number.decimal(l_digits: 2, r_digits: 2) : 0,
          "vino" => Faker::Boolean.boolean ? Faker::Number.decimal(l_digits: 2, r_digits: 2) : 0
        },
        chef: Chef.all.sample,
      )

      # Download and attach the image
      Faker::Number.between(from: 1, to: 5).times do |j|
        image_url = Faker::LoremFlickr.image(size: "300x300", search_terms: [ 'food', 'menu' ])
        downloaded_image = URI.open(image_url)
        menu.images.attach(io: downloaded_image, filename: "menu_#{j + 1}.jpg")
      end

      product = Stripe::Product.create({
        name: menu.titolo,
        active: true,
        description: menu.descrizione,
        metadata: {
          menu_id: menu.id
        }
      })
      menu.stripe_product_id = product.id

      price = Stripe::Price.create({
        product: menu.stripe_product_id,
        unit_amount: (menu.prezzo_persona * 100).to_i,
        currency: "eur"
      })
      menu.stripe_price_id = price.id
      puts "Stripe product id: #{menu.stripe_product_id}"
      puts "Stripe price id: #{menu.stripe_price_id}"
      if menu.extra["vino"].to_f > 0
        menu.stripe_vino_price_id = Stripe::Price.create({
        product: "prod_QpoyNULQRqG7ES",
        unit_amount: (menu.extra["vino"].to_f * 100).to_i,
        currency: "eur"
      }).id
      end
      if menu.extra["miseenplace"].to_f > 0
        menu.stripe_miseenplace_price_id = Stripe::Price.create({
          product: "prod_QpoyYxH4483LdR",
          unit_amount: (menu.extra["miseenplace"].to_f * 100).to_i,
          currency: "eur"
        }).id
      end


      # Salva il menu temporaneamente senza validazioni
      menu.save!(validate: false)

      # Creazione di piatti associati al menu
      num_dishes = rand(1..6) # Numero casuale di piatti tra 1 e 6
      portate = [ 'Antipasto', 'Primo', 'Secondo', 'Dolce' ]
      num_dishes.times do |j|
        Dish.create!(
          menu: menu,
          nome: Faker::Food.dish,
          tipo_portata: portate[j % portate.length],
          ingredienti: Faker::Food.ingredient
        )
      end

      # Salva il menu con i piatti associati
      menu.save!
      puts "Created menu #{i}"
    end
  end


# Creiamo delle prenotazioni
100.times do |u|
  # Da una settimana fa a tra una settimana
  data_prenotazione = Faker::Date.between(from: 2.week.ago, to: 2.week.from_now)
  # Cerco un menu disponibile per quella data
  menu = Menu.disponibili_per_data(data_prenotazione).sample
  # Cerco un cliente disponibile per quella data
  client = Client.disponibile_per_data(data_prenotazione).sample
  next if menu.nil? || client.nil? # Se non ci sono menu o clienti disponibili, salto la creazione della prenotazione

  puts "Menu: #{menu.titolo}, Client: #{client.user.email}"
  num_persone = Faker::Number.between(from: menu.min_persone, to: menu.max_persone)
  # Creo la prenotazione
  reservation = Reservation.find_or_initialize_by(
    menu: menu,
    client: client,
    data_prenotazione: data_prenotazione,
    chef: menu.chef,
    num_persone: num_persone,
    tipo_pasto: Reservation.tipo_pastos.keys.sample,
    indirizzo_consegna: client.indirizzo,
    extra: {
      "miseenplace" => menu.extra["miseenplace"] > 0 ? Faker::Boolean.boolean : false,
      "vino" => menu.extra["vino"] > 0 ? Faker::Boolean.boolean : false
    },
    stato: Reservation.statos.keys.sample,
    stripe_payment_intent_id: Faker::Alphanumeric.alphanumeric(number: 20),
  )
  reservation.prezzo = reservation.menu.prezzo_persona * reservation.num_persone
  reservation.save!
  puts "Created reservation #{reservation.inspect}"
end


# Creiamo delle recensioni
# Per ogni prenotazione, se è completata, creiamo una recensione
Reservation.where(stato: :completata).each do |reservation|
    recensioneMenu = Review.create!(
        valutazione: Faker::Number.between(from: 1, to: 5),
        commento: Faker::Restaurant.review,
        tipo_recensione: reservation.menu,
        reservation: reservation,
    )
    valutazioneChef = Review.create!(
        valutazione: Faker::Number.between(from: 1, to: 5),
        tipo_recensione: reservation.menu.chef,
        reservation: reservation,
    )
    valutazioneClient = Review.create!(
        valutazione: Faker::Number.between(from: 1, to: 5),
        tipo_recensione: reservation.client,
        reservation: reservation,
    )
    puts "RecMenu #{recensioneMenu.tipo_recensione_type}, RecChef #{valutazioneChef.tipo_recensione_type}, RecClient #{valutazioneClient.tipo_recensione_type}"
    puts "Created reviews for reservation #{reservation.id}"
end

# Creo cinque prenotazione completata senza recensioni
5.times.with_index do |i|
  ActiveRecord::Base.transaction do
    menu = Menu.find_or_initialize_by(titolo: Faker::Food.dish)
    menu.assign_attributes(
      descrizione: Faker::Food.description,
      prezzo_persona: Faker::Number.decimal(l_digits: 2, r_digits: 2),
      min_persone: Faker::Number.between(from: 2, to: 10),
      max_persone: Faker::Number.between(from: 11, to: 20),
      tipo_cucina: Faker::Food.dish,
      allergeni: {
        "glutine" => Faker::Boolean.boolean,
        "soia" => Faker::Boolean.boolean,
        "noci" => Faker::Boolean.boolean,
        "lattosio" => Faker::Boolean.boolean,
        "crostacei" => Faker::Boolean.boolean,
        "arachidi" => Faker::Boolean.boolean
      },
      preferenze_alimentari: {
        "vegano" => Faker::Boolean.boolean,
        "glutine" => Faker::Boolean.boolean
      },
      adattabile: {
        "preferenze" => {
          "vegano" => Faker::Boolean.boolean,
          "glutine" => Faker::Boolean.boolean
        },
        "allergeni" => {
          "glutine" => Faker::Boolean.boolean,
          "soia" => Faker::Boolean.boolean,
          "noci" => Faker::Boolean.boolean,
          "lattosio" => Faker::Boolean.boolean,
          "crostacei" => Faker::Boolean.boolean,
          "arachidi" => Faker::Boolean.boolean
        }
      },
      extra: {
        "miseenplace" => Faker::Boolean.boolean ? Faker::Number.decimal(l_digits: 2, r_digits: 2) : 0,
        "vino" => Faker::Boolean.boolean ? Faker::Number.decimal(l_digits: 2, r_digits: 2) : 0
      },
      chef: User.find_by(email: 'chef@chef.it').chef,
    )

    # Download and attach the image
    Faker::Number.between(from: 1, to: 5).times do |j|
      image_url = Faker::LoremFlickr.image(size: "300x300", search_terms: [ 'food', 'menu' ])
      downloaded_image = URI.open(image_url)
      menu.images.attach(io: downloaded_image, filename: "menu_#{j + 1}.jpg")
    end

    product = Stripe::Product.create({
      name: menu.titolo,
      active: true,
      description: menu.descrizione,
      metadata: {
        menu_id: menu.id
      }
    })
    menu.stripe_product_id = product.id

    price = Stripe::Price.create({
      product: menu.stripe_product_id,
      unit_amount: (menu.prezzo_persona * 100).to_i,
      currency: "eur"
    })
    menu.stripe_price_id = price.id
    puts "Stripe product id: #{menu.stripe_product_id}"
    puts "Stripe price id: #{menu.stripe_price_id}"
    if menu.extra["vino"].to_f > 0
      menu.stripe_vino_price_id = Stripe::Price.create({
      product: "prod_QpoyNULQRqG7ES",
      unit_amount: (menu.extra["vino"].to_f * 100).to_i,
      currency: "eur"
    }).id
    end
    if menu.extra["miseenplace"].to_f > 0
      menu.stripe_miseenplace_price_id = Stripe::Price.create({
        product: "prod_QpoyYxH4483LdR",
        unit_amount: (menu.extra["miseenplace"].to_f * 100).to_i,
        currency: "eur"
      }).id
    end


    # Salva il menu temporaneamente senza validazioni
    menu.save!(validate: false)

    # Creazione di piatti associati al menu
    num_dishes = rand(1..6) # Numero casuale di piatti tra 1 e 6
    portate = [ 'Antipasto', 'Primo', 'Secondo', 'Dolce' ]
    num_dishes.times do |j|
      Dish.create!(
        menu: menu,
        nome: Faker::Food.dish,
        tipo_portata: portate[j % portate.length],
        ingredienti: Faker::Food.ingredient
      )
    end

    # Salva il menu con i piatti associati
    menu.save!
    puts "Created menu #{i}"
  end
end



5.times do |u|
  # Da una settimana fa a tra una settimana
  data_prenotazione = Faker::Date.between(from: 10.months.ago, to: 3.week.ago)
  # Cerco un menu disponibile per quella data
  chef_user = User.find_by(email: 'chef@chef.it')
  menu = chef_user.chef.menus.sample
  # Cerco il cliente client
  client = User.find_by(email: 'client@client.it').client
  next if menu.nil? || client.nil? # Se non ci sono menu o clienti disponibili, salto la creazione della prenotazione
  puts "Menu: #{menu.titolo}, Client: #{client.user.email}"
  num_persone = Faker::Number.between(from: menu.min_persone, to: menu.max_persone)
  # Creo la prenotazione
  reservation = Reservation.find_or_initialize_by(
    menu: menu,
    client: client,
    data_prenotazione: data_prenotazione,
    chef: menu.chef,
    num_persone: num_persone,
    tipo_pasto: Reservation.tipo_pastos.keys.sample,
    indirizzo_consegna: client.indirizzo,
    extra: {
      "miseenplace" => menu.extra["miseenplace"] > 0 ? Faker::Boolean.boolean : false,
      "vino" => menu.extra["vino"] > 0 ? Faker::Boolean.boolean : false
    },
    stato: :completata,
    stripe_payment_intent_id: Faker::Alphanumeric.alphanumeric(number: 20),
  )
  reservation.prezzo = reservation.menu.prezzo_persona * reservation.num_persone
  reservation.save!
  puts "Creata prenotazione senza recensioni #{reservation.inspect}"
end
