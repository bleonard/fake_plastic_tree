require File.expand_path('../../lib/fake_plastic_tree', __FILE__)

require 'rspec'

Braintree::Configuration.environment = :sandbox
Braintree::Configuration.merchant_id = "something"
Braintree::Configuration.public_key  = "public_key"
Braintree::Configuration.private_key = "private_key"


RSpec.configure do |config|
  
end