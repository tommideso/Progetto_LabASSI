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
          "mise en place" => "true",
          "vino" => Faker::Boolean.boolean
        },
        prezzo_extra: Faker::Number.decimal(l_digits: 2, r_digits: 2),
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
