class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  AUTH_VALUES = { 'guest' => 0, 'staff' => 1, 'admin' => 2 }.freeze

  def render_with_errors(*args, errors:)
    @errors = errors
    render(*args)
  end

  def check_auth(auth, fall_back)
    authorized = AUTH_VALUES[Rails.config.authority].to_i >= AUTH_VALUES[auth]
    render_with_errors(fall_back, 'Not permitted operation') unless authorized
    authorized
  end
end
