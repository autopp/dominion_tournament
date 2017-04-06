class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def render_with_errors(*args, errors:)
    @errors = errors
    render(*args)
  end
end
