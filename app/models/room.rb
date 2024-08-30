class Room < ApplicationRecord
    # le stanze devono avere un id univoco
    validates_uniqueness_of :name
end
