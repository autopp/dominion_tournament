class Round < ApplicationRecord
  belongs_to :tournament
  has_many :tables, dependent: :destroy
end
