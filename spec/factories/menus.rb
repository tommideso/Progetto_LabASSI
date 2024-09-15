FactoryBot.define do
    factory :menu do
      titolo { Faker::Food.dish }
      descrizione { Faker::Food.description }
      prezzo_persona { Faker::Number.decimal(l_digits: 2, r_digits: 2) }
      min_persone { Faker::Number.between(from: 2, to: 10) }
      max_persone { Faker::Number.between(from: 11, to: 20) }
      tipo_cucina { Faker::Food.dish }
      allergeni {
        {
          "glutine" => Faker::Boolean.boolean,
          "soia" => Faker::Boolean.boolean,
          "noci" => Faker::Boolean.boolean,
          "lattosio" => Faker::Boolean.boolean,
          "crostacei" => Faker::Boolean.boolean,
          "arachidi" => Faker::Boolean.boolean
        }
      }
      preferenze_alimentari {
        {
          "vegano" => Faker::Boolean.boolean,
          "glutine" => Faker::Boolean.boolean
        }
      }
      adattabile {
        {
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
        }
      }
      extra {
        {
          "miseenplace" => 1.50,
          "vino" => Faker::Boolean.boolean ? Faker::Number.decimal(l_digits: 2, r_digits: 2) : 0
        }
      }
      disattivato { false }
      association :chef

      # Usa after(:build) per aggiungere i piatti prima della validazione
      after(:build) do |menu|
        menu.dishes << FactoryBot.build(:dish, menu: menu)
      end

      # Usa after(:build) per fare le chiamate API a Stripe
      after(:build) do |menu|
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
      end
    end
  end
