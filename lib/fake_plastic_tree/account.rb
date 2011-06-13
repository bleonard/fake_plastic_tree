module FakePlasticTree
  module Account
    
    protected

    def merchant_id
      Braintree::Configuration.merchant_id
    end

    def merchant_account_id
      "my_merchant_account_id"
    end

    def status_history_user
      "my_user_id"
    end
    
  end
end