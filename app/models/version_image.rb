# Classe per la gestione delle immagini associate ad una versione dell'istanza di Menu
class VersionImage < ApplicationRecord
  belongs_to :version, class_name: "PaperTrail::Version"
  has_many_attached :images
end
