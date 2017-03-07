class Tournament < ApplicationRecord
  has_many :players, dependent: :destroy
  has_many :rounds, dependent: :destroy
end
