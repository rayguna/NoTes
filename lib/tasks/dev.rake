desc "Fill the database tables with some sample data"
task({ :sample_data => :environment }) do
  p "Creating sample data"

  # Destroy existing data
  if Rails.env.development?
    Favorite.destroy_all
    Topic.destroy_all
    Note.destroy_all
    User.destroy_all

    # Reset primary key sequences
    ActiveRecord::Base.connection.reset_pk_sequence!('favorites')
    ActiveRecord::Base.connection.reset_pk_sequence!('topics')
    ActiveRecord::Base.connection.reset_pk_sequence!('notes')
    ActiveRecord::Base.connection.reset_pk_sequence!('users')
  end

  topics_list = [
    "physics", "biology", "chemistry", "rubik's cube", "behavioral interview", 
    "technical interview", "electronics", "options trading", 
    "quantitative finance", "elevator pitch"
  ]

  # Generate five fake users
  5.times do
    name = Faker::Name.first_name
    user = User.create(
      email: "#{name}@example.com",
      password: "password",
      username: name
    )

    # Generate five unique random topics for each user
    topics_list.sample(5).each do |topic_name|
      Topic.create(
        name: topic_name,
        user: user
      )
    end
  end

  p "#{User.count} users have been created."
  p "#{Topic.count} topics have been created."
end
