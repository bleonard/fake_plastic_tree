module FakePlasticTree
  module Customers

    protected
    
    def customer_success(response)
      Braintree::SuccessfulResult.new(:customer => Braintree::Customer._new(Braintree::Configuration.gateway, response[:customer]))
    end
    
    def customer_id_from_hash(hash)
      keys = [:id, :first_name, :last_name]
      encode_prop(hash, keys)
      hash[:id] || rand(999999).to_s
    end

    def hash_from_customer_id(customer_id)
      decode_prop(customer_id)
    end
    
    def credit_card_from_hash(hash)
      keys = [:token, :customer_id, :number, :expiration_date, :expiration_month, :expiration_year]
      encode_prop(hash, keys)
      hash[:token] || rand(999999).to_s
    end

    def hash_from_credit_card(credit_card)
      decode_prop(credit_card)
    end
    
    def card_success(response)
      Braintree::SuccessfulResult.new(:credit_card => Braintree::CreditCard._new(Braintree::Configuration.gateway, response[:credit_card]))
    end
    
  end
end