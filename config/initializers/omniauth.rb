# config/initializers/omniauth.rb
case Rails.env
  when "production"
    Rails.application.config.middleware.use OmniAuth::Builder do
      provider :google_oauth2,
               ENV['OAUTH_CLIENT_ID'],
               ENV['OAUTH_CLIENT_SECRET'],
               {name: "google_login", approval_prompt: ''}
    end
  when "development"

    Rails.application.config.middleware.use OmniAuth::Builder do
      provider :google_oauth2,
               'OAUTH_CLIENT_ID',
               'OAUTH_CLIENT_SECRET',
               {name: "google_login", approval_prompt: ''}
    end

    OmniAuth.config.test_mode = true

    OmniAuth.config.mock_auth[:google_login] = {
        "provider" => "google_oauth2",
        "uid" => "123456789",
        "info" => {
            "name" => "John Doe",
            "email" => "john@andromoney.com",
            "first_name" => "John",
            "last_name" => "Doe",
            "image" => "https://lh3.googleusercontent.com/url/photo.jpg"
        },
        "credentials" => {
            "token" => "token",
            "refresh_token" => "another_token",
            "expires_at" => 2041008560,
            "expires" => true
        }
    }
  else
    Rails.application.config.middleware.use OmniAuth::Builder do
      provider :google_oauth2,
               'OAUTH_CLIENT_ID',
               'OAUTH_CLIENT_SECRET',
               {name: "google_login", approval_prompt: ''}
    end
end