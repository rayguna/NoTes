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
  data_directory = Rails.root.join('lib/tasks/data')

  # Check if the directory exists
  unless Dir.exist?(data_directory)
    p "Data directory does not exist: #{data_directory}"
    next
  end

  # Get all text files in the directory
  all_files = Dir.glob(data_directory.join('*.txt'))

  # Debug output
  p "All files found: #{all_files}"

  # Generate five fake users
  5.times do
    name = Faker::Name.first_name
    user = User.create(
      email: "#{name}@example.com",
      password: "password",
      username: name
    )

    # Select five random files for the current user
    selected_files = all_files.sample(5)

    # Debug output
    p "Selected files for user #{user.username}: #{selected_files}"

    # Create topics and notes for each selected file
    selected_files.each do |file_path|
      topic_name = File.basename(file_path, ".txt")

      # Create the topic
      topic = Topic.create(
        name: topic_name,
        topic_type: "note",
        user: user
      )

      # Read the contents of the file, skipping the header line
      File.foreach(file_path).with_index do |line, line_num|
      
        # Debug output for each line
        p "Processing line: #{line.chomp}"

        # Skip lines that are empty or contain only whitespace
        next if line.strip.empty?

        # Split the line by the first semicolon only
        parts = line.chomp.split(';', 2)
        if parts.size < 2
          p "Skipping invalid line: #{line.chomp}"
          next
        end

        title = parts[0].strip
        content = parts[1].strip

        # Create the note
        Note.create(
          title: title,
          content: content,
          topic: topic,
          user: user
        )
      end
    end
  end

  p "Sample data creation complete."
end
