json.extract! favorite, :id, :note_id, :user_id, :created_at, :updated_at
json.url favorite_url(favorite, format: :json)
