class Round
  include ActiveModel::Model

  attr_accessor :tournament, :number, :tables

  define_model_callbacks :initialize

  def initialize(*args)
    run_callbacks :initialize do
      super
    end
  end

  after_initialize do
    @tables ||= (1..((tournament.players.count + 3) / 4)).map do |i|
      Table.new(tournament: tournament, round_number: number, number: i)
    end
  end

  def finished?
    tournament.finished_count >= number
  end

  def finish!
    return [false, ['Already finished']] if finished?

    not_completed_tables = self.not_completed_tables
    if !not_completed_tables.empty?
      return [false, not_completed_tables.map { |table| "Table #{table.number} is not completed" }]
    end

    ActiveRecord::Base.transaction do
      tables.each(&:finish!)
      tournament.finished_count += 1
      tournament.has_ongoing_round = false
      tournament.save!
    end

    [true, ["Round #{number} is finished!"]]
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
