desc "Fill the database tables with some sample data"
task sample_data: :environment do
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

  # Path to the directory containing the text files
  data_directory = "path/to/your/text/files"

  # Generate five fake users
  5.times do
    name = Faker::Name.first_name
    user = User.create(
      email: "#{name}@example.com",
      password: "password",
      username: name
    )

    # Get all text files in the directory
    all_files = Dir.glob("#{data_directory}/*.txt")

    # Select five random files for the current user
    selected_files = all_files.sample(5)

    # Read each selected text file
    selected_files.each do |file_path|
      topic_name = File.basename(file_path, ".txt")

      # Create the topic
      topic = Topic.create(
        name: topic_name,
        user: user
      )

      # Read the contents of the file
      File.foreach(file_path).with_index do |line, line_num|
        next if line_num == 0 # Skip header line

        title, content = line.chomp.split(',', 2)

        # Create the note
        Note.create(
          title: title,
          content: content,
          topic: topic
        )
      end
    end
  end

  p "#{User.count} users have been created."
  p "#{Topic.count} topics have been created."
  p "#{Note.count} notes have been created."
end
