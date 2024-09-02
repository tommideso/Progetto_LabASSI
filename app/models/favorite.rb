class Favorite < ApplicationRecord
  belongs_to :menu
  belongs_to :client
end
