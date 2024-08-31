class Reservation < ApplicationRecord
  belongs_to :user
  # associazione rispetto il menu
  belongs_to :menu
  # usiamo un'associazione "personalizzata" con paper_trail 
  belongs_to :menu_version, class_name: 'PaperTrail::Version', optional: true
  # ed un'altra associata personalizzata con il solo scope di percorrere l'associazione in maniera più veloce
  has_one :versioned_menu, through: :menu_version, source: :item, source_type: 'Menu'

  # aggiunta dell'associazione menu_version_id
  belongs_to :menu_version, optional: true

  # dopo la creazione di ogni prenotazione, 'salviamo' una versione del menù e la associamo alla prenotazione
  # salvandone la versione all'interno della colonna "menu_version_id"
  after_create :create_menu_version

  private

  def create_menu_version
    # TODO HO MESSO DEL DEBUGGING CHE PERÒ PUÒ ESSERE TOLTO SE SIAMO SICURI FUNZIONI :)
    Rails.logger.debug "Menu: #{menu.inspect}"

    if menu.present?
      Rails.logger.debug "Menu is present. Attempting to create version."

      if menu.valid?
        PaperTrail.request(enabled: true) do
          menu_version = menu.paper_trail.save_with_version
          Rails.logger.debug "Menu Version: #{menu_version.inspect}"
          
          if menu_version.present?
            update!(menu_version_id: menu_version.id)
          else
            Rails.logger.error "Menu version is nil. Cannot update reservation with menu version."
          end
        end
      else
        Rails.logger.error "Menu is not valid: #{menu.errors.full_messages.join(", ")}"
      end
    else
      Rails.logger.error "Menu is nil. Cannot create menu version."
    end
  end
end