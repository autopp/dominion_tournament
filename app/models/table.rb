class Table < ApplicationRecord
  belongs_to :round
  has_many :scores, dependent: :destroy
end
