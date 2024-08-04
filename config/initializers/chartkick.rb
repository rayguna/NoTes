# config/initializers/chartkick.rb
require 'cairo'

Chartkick.configure do |config|
  config.cairo = true # Enable Cairo rendering for chart images
end
