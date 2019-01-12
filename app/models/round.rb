class Round < ApplicationRecord
  belongs_to :tournament

  attr_reader :table_entities

  after_find do
    @table_entities = (1..((tournament.players.count + 3) / 4)).map do |i|
      TableEntity.new(tournament: tournament, round_number: number, number: i)
    end
  end

  def finished?
    tournament.finished_count >= number
  end

  def finish!
    ActiveRecord::Base.transaction do
      table_entities.each(&:finish!)
      tournament.finished_count += 1
      tournament.save!
    end
  end

  def not_completed_tables
    table_entities.reject do |table|
      table.scores.all?(&:complete?)
    end
  end

  def rollback!
    table_entities.each do |table|
      table.scores.each do |score|
        score.update!(tp_numerator: nil, tp_denominator: nil, rank: nil)
      end
    end
  end
end
