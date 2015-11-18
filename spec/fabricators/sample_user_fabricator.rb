Fabricator(:sample_user, from: :user) do
  name {"John Doe"}
  email {"john@andromoney.com"}
  provider {"google_login"}
end