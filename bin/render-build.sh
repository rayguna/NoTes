#!/usr/bin/env bash
# exit on error
set -o errexit

# Install Ruby dependencies
bundle install

# Configure AWS CLI and download Python dependencies from S3

# Alternatively, use requirements.txt if you prefer:
# pip install -r requirements.txt

# Precompile Rails assets and migrate the database
echo "Precompiling assets and migrating the database..."
bundle exec rake assets:precompile
bundle exec rake assets:clean 
bundle exec rake db:migrate
