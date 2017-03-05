class Player < ApplicationRecord
  belongs_to :tournament
  has_many :scores
end
