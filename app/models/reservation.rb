class Reservation < ApplicationRecord
  belongs_to :user
  # collegamento verso menu
  belongs_to :menu

  # versioning tramite gemma paper_trail
  has_paper_trail
end
