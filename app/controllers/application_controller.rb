class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  AUTH_VALUES = { 'guest' => 0, 'staff' => 1, 'admin' => 2 }.freeze

  def render_with_errors(*args, errors:)
    @errors = errors
    render(*args)
  end

  def authorized?(auth)
    AUTH_VALUES[Rails.configuration.authority].to_i >= AUTH_VALUES[auth]
  end

  def check_auth(auth, fall_back:)
    authorized = authorized?(auth)
    render_with_errors(fall_back, errors: ['Not permitted operation']) if !authorized
    authorized
  end
end
