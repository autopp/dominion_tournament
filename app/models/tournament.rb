class Tournament < ApplicationRecord
  has_many :players, dependent: :destroy
  has_many :rounds, dependent: :destroy

  def self.create_with_players(player_names)
    t = new
    ActiveRecord::Base.transaction do
      t.save!
      player_names.each do |name|
        t.players.create!(name: name)
      end
    end
    t
  end
end
