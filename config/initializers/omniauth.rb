# frozen_string_literal: true

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :github, ENV.fetch("GITHUB_CLIENT_ID", ""), ENV.fetch("GITHUB_CLIENT_SECRET", ""), scope: "user"
end

if Rails.env.test?
  OmniAuth.config.test_mode = true

  OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new(
    provider: "github",
    uid: "",
    info: { email: "", nickname: "" },
    extra: {}
  )

  OmniAuth.config.before_callback_phase do |env|
    params = env["omniauth.params"] || {}
    email = params["email"] || "user@test.com"
    env["omniauth.auth"] = OmniAuth::AuthHash.new(
      provider: "github",
      uid: email,
      info: { email:, nickname: email.split("@").first },
      credentials: { token: "test_token" }
    )
  end
end
