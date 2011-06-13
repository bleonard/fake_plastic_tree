module FakePlasticTree
  module Responses
    
    protected

    def transaction_success(response)
      Braintree::SuccessfulResult.new(:transaction => Braintree::Transaction._new(Braintree::Configuration.gateway, response[:transaction]))
    end

    def customer_success(response)
      Braintree::SuccessfulResult.new(:customer => Braintree::Customer._new(Braintree::Configuration.gateway, response[:customer]))
    end

    def card_success(response)
      Braintree::SuccessfulResult.new(:credit_card => Braintree::CreditCard._new(Braintree::Configuration.gateway, response[:credit_card]))
    end

    def any_error(response)
      Braintree::ErrorResult.new(Braintree::Configuration.gateway, response[:api_error_response])
    end
    
    
  end
end  
  