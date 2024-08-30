class Room < ApplicationRecord
    # le stanze devono avere un id univoco
    validates_uniqueness_of :name
    # vincoli necessari per la chat
    has_many :messages, dependent: :destroy
end
