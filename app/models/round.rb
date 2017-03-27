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
end
