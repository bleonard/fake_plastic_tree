require 'base64'
require 'braintree'

require 'fake_plastic_tree/create_customer'
require 'fake_plastic_tree/create_card'
require 'fake_plastic_tree/auth_only'
require 'fake_plastic_tree/auth_capture'
require 'fake_plastic_tree/prior_auth_capture'
require 'fake_plastic_tree/prior_auth_void'


module FakePlasticTree
  class Gateway
    extend CreateCustomer
    extend CreateCard
    extend AuthOnly
    extend AuthCapture
    extend PriorAuthCapture
    extend PriorAuthVoid

    protected

    def self.merchant_id
      Braintree::Configuration.merchant_id
    end

    def self.merchant_account_id
      "my_merchant_account_id"
    end

    def self.status_history_user
      "my_user_id"
    end

    def self.transaction_success(response)
      Braintree::SuccessfulResult.new(:transaction => Braintree::Transaction._new(Braintree::Configuration.gateway, response[:transaction]))
    end

    def self.customer_success(response)
      Braintree::SuccessfulResult.new(:customer => Braintree::Customer._new(Braintree::Configuration.gateway, response[:customer]))
    end

    def self.card_success(response)
      Braintree::SuccessfulResult.new(:credit_card => Braintree::CreditCard._new(Braintree::Configuration.gateway, response[:credit_card]))
    end

    def self.any_error(response)
      Braintree::ErrorResult.new(Braintree::Configuration.gateway, response[:api_error_response])
    end

    def self.encode_prop(hash, keys)
      prop = {}
      prop[:time] ||= Time.now.to_i
      prop[:random] ||= rand(10000000)

      keys.each do |key|
        prop[key] = hash[key] if hash[key]
      end

      dump = Marshal::dump(prop)
      out = Base64.encode64(dump)
      out = out[0...-1] if out[-1, 1] == "\n"
      out
    end

    def self.decode_prop(out)
      out = out + "\n"
      dump = Base64.decode64(out)
      prop = Marshal::load(dump)
      prop
    rescue
      {} # empty hash
    end

    def self.transaction_id_from_hash(hash)
      keys = [:customer_id, :payment_method_token, :amount]
      encode_prop(hash, keys)
    end

    def self.hash_from_transaction_id(transaction_id)
      prop = decode_prop(transaction_id)
      raise Braintree::BraintreeError, "no amount in hash" unless prop[:amount].to_f > 0
      prop
    end

    def self.customer_id_from_hash(hash)
      keys = [:id, :first_name, :last_name]
      encode_prop(hash, keys)
      hash[:id] || rand(999999).to_s
    end

    def self.hash_from_customer_id(customer_id)
      prop = decode_prop(customer_id)
      prop
    end

    def self.credit_card_from_hash(hash)
      keys = [:token, :customer_id, :number, :expiration_date, :expiration_month, :expiration_year]
      encode_prop(hash, keys)
      hash[:token] || rand(999999).to_s
    end

    def self.hash_from_credit_card(credit_card)
      prop = decode_prop(credit_card)
      prop
    end
  end
end
