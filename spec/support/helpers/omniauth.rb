module Omniauth

  module Mock
    def auth_mock(usr)
      OmniAuth.config.mock_auth[:google] = {
        'provider' => 'google_oauth2',
        'uid' => '123456789',
        'info' => {
            'name' => usr.name,
            'email' => usr.email,
            'first_name' => 'John',
            'last_name' => 'Doe',
            'image' => 'https://lh3.googleusercontent.com/url/photo.jpg'
        },
        'credentials' => {
            'token' => 'token',
            'refresh_token' => 'another_token',
            'expires_at' => 2041008560,
            'expires' => true
        }
      }
    end
  end

  module SessionHelpers
    def signin(usr)
        visit '/'
        expect(page).to have_content('Sign in')
        auth_mock(usr)
        visit '/auth/google_login/callback'
    end
  end
end