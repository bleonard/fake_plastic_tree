require 'base64'
require 'braintree'

require 'fake_plastic_tree/account'
require 'fake_plastic_tree/hashes'

require 'fake_plastic_tree/customers'
require 'fake_plastic_tree/transactions'


require 'fake_plastic_tree/create_customer'
require 'fake_plastic_tree/create_card'
require 'fake_plastic_tree/auth_only'
require 'fake_plastic_tree/auth_capture'
require 'fake_plastic_tree/prior_auth_capture'
require 'fake_plastic_tree/prior_auth_void'


module FakePlasticTree
  class Gateway
    extend Account
    extend Hashes
    
    extend Customers
    extend Transactions
    
    extend CreateCustomer
    extend CreateCard
    extend AuthOnly
    extend AuthCapture
    extend PriorAuthCapture
    extend PriorAuthVoid
  end
end
