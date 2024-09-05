module PaperTrail
    # Usato per la gestione delle versioni di un'istanza di Menu
    class Version < ActiveRecord::Base
        include PaperTrail::VersionConcern
        has_one :version_images, class_name: "VersionImage", foreign_key: "version_id"
        belongs_to :item, polymorphic: true
    end
end
