module ApplicationHelper
  def format_point(point)
    point.is_a?(Integer) || point.denominator == 1 ? point.numerator : format('%.4g', point.to_f)
  end
end
