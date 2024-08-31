class Reservation < ApplicationRecord
  belongs_to :user
  # collegamento verso menu
  belongs_to :menu
end
