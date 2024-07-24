json.extract! user, :id, :email, :encrypted_password, :remember_created_at, :reset_password_sent_at, :reset_password_token, :username, :created_at, :updated_at
json.url user_url(user, format: :json)
