class Round < ApplicationRecord
  belongs_to :tournament
  has_many :tables, dependent: :destroy

  def finish!
    ActiveRecord::Base.transaction do
      tables.each(&:finish!)
      tournament.finished_count += 1
      tournament.save!
    end
  end

  def not_completed_tables
    tables.reject do |table|
      table.scores.all?(&:complete?)
    end
  end

  def rollback!
    tables.each do |table|
      table.scores.each do |score|
        score.update!(tp_numerator: nil, tp_denominator: nil, rank: nil)
      end
    end
  end
end
