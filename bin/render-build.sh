#!/usr/bin/env bash
# exit on error
set -o errexit

# Install Ruby dependencies
bundle install

# Configure AWS CLI and download Python dependencies from S3

# Check if AWS CLI is installed, if not, install it
if ! command -v aws &> /dev/null; then
  echo "Installing AWS CLI..."
  curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
  unzip awscliv2.zip
  ./aws/install
fi

# Configure AWS credentials (ensure these are set in your Render environment variables)
export AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID
export AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY
export AWS_DEFAULT_REGION=$AWS_DEFAULT_REGION

# Download the packaged Python dependencies from S3
echo "Downloading Python wheels from S3..."
aws s3 cp s3://your-bucket-name/wheels.tar.gz .

# Extract the packages
echo "Extracting Python wheels..."
tar -xzf wheels.tar.gz

# Install the Python dependencies using wheel files
echo "Installing Python dependencies from wheels..."
pip install wheels/*.whl

# Alternatively, use requirements.txt if you prefer:
# pip install -r requirements.txt

# Precompile Rails assets and migrate the database
echo "Precompiling assets and migrating the database..."
bundle exec rake assets:precompile
bundle exec rake assets:clean 
bundle exec rake db:migrate
