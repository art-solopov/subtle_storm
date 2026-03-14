# frozen_string_literal: true

Rails.root.glob('lib/warden/**/*.rb').each { |e| require e }

Warden::Strategies.add(:password, Warden::Strategies::Password)

Warden::Manager.after_authentication do |user, auth, _opts|
  request = auth.request
  user_session = user.sessions.create!(user_agent: request.user_agent, ip_address: request.remote_ip)
  request.cookie_jar.signed.permanent[:session_id] = { value: user_session.id, httponly: true, same_site: :lax }
end

Warden::Manager.serialize_into_session do |user|
  user.to_global_id.to_s
end

Warden::Manager.serialize_from_session do |gid|
  GlobalID::Locator.locate gid
end

Rails.configuration.middleware.use Warden::Manager do |manager|
  manager.default_strategies :password
end
