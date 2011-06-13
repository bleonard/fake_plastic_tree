module FakePlasticTree
  module Transactions

    protected
    
    def any_error(response)
      Braintree::ErrorResult.new(Braintree::Configuration.gateway, response[:api_error_response])
    end
    
    def transaction_success(response)
      Braintree::SuccessfulResult.new(:transaction => Braintree::Transaction._new(Braintree::Configuration.gateway, response[:transaction]))
    end

    def transaction_id_from_hash(hash)
      keys = [:customer_id, :payment_method_token, :amount]
      encode_prop(hash, keys)
    end

    def hash_from_transaction_id(transaction_id)
      prop = decode_prop(transaction_id)
      raise Braintree::BraintreeError, "no amount in hash" unless prop[:amount].to_f > 0
      prop
    end
    
  end
end