#!/usr/bin/env bash
# exit on error
set -o errexit

# Install Ruby dependencies
bundle install

# Install Python dependencies
pip3 install -r requirements.txt

# For Ruby on Rails apps uncomment these lines to precompile assets and migrate your database.
bundle exec rake assets:precompile
bundle exec rake assets:clean 
bundle exec rake db:migrate
