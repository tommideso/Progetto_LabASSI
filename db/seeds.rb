# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

menu1 = Menu.find_or_initialize_by(titolo: "Menu Vegano")
menu1.update!(
    descrizione: "Un menu adatto a chi segue una dieta vegana.",
    prezzo_persona: 25.50,
    min_persone: 2,
    max_persone: 10,
    tipo_cucina: "Vegano",
    allergeni: { "glutine" => false, "soia" => true, "noci" => true, "lattosio" => false, "crostacei" => true, "arachidi" => false },
    preferenze_alimentari: { "vegano" => true, "glutine" => true },
    adattabile: {
        "preferenze" => {
            "vegano" => true,
            "glutine" => false
        },
        "allergeni" => {
            "glutine" => false, 
            "soia" => true, 
            "noci" => true, 
            "lattosio" => false, 
            "crostacei" => true, 
            "arachidi" => false
        }
    },
    extra: { "bevande_incluse" => false, "dessert" => true },
    prezzo_extra: 5,
    disattivato: false
)

menu2 = Menu.find_or_initialize_by(titolo: "Menu Carnivoro")
menu2.update!(
    descrizione: "Un menu ricco di piatti a base di carne, ideale per gli amanti della carne.",
    prezzo_persona: 30.00,
    min_persone: 3,
    max_persone: 12,
    tipo_cucina: "Carnivoro",
    allergeni: { "glutine" => false, "soia" => true, "noci" => true, "lattosio" => false, "crostacei" => true, "arachidi" => false },
    preferenze_alimentari: { "vegano" => true, "glutine" => false },
    adattabile: {
        "preferenze" => {
            "vegano" => true,
            "glutine" => false
        },
        "allergeni" => {
            "glutine" => false, 
            "soia" => true, 
            "noci" => true, 
            "lattosio" => false, 
            "crostacei" => true, 
            "arachidi" => false
        }
    },
    extra: { "bevande_incluse" => true, "dessert" => true },
    prezzo_extra: 10,
    disattivato: false
)
)