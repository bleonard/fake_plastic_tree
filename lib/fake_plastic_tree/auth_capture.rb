module FakePlasticTree
  module AuthCapture
    
    def auth_capture(hash)
      if hash[:customer_id]
        response = response_auth_capture_customer(hash)
      else
        response = response_auth_capture_card(hash)
      end
      transaction_success(response)
    end
    
    protected
    
    def response_auth_capture_card(hash)
      time = Time.now
      amount = hash[:amount]
      transaction_id = transaction_id_from_hash(hash)

      {:transaction=>
               {:customer=>{:company=>nil, :first_name=>nil, :last_name=>nil, :email=>nil, :phone=>nil, :id=>nil, :website=>nil, :fax=>nil},
                :refund_ids=>[], :type=>"sale", :cvv_response_code=>"I", :avs_street_address_response_code=>"I", :refund_id=>nil, :descriptor=>{:phone=>nil, :name=>nil},
                :status=>"submitted_for_settlement", :subscription_id=>nil, :refunded_transaction_id=>nil, :merchant_account_id=>merchant_account_id, :processor_response_code=>"1000",
                :currency_iso_code=>"USD", :created_at=>time, :order_id=>nil, :processor_response_text=>"Approved",
                :billing=>{
                        :postal_code=>nil, :country_code_alpha3=>nil, :company=>nil, :first_name=>nil, :country_code_alpha2=>nil, :country_code_numeric=>nil, :last_name=>nil,
                        :street_address=>nil, :country_name=>nil, :locality=>nil, :region=>nil, :extended_address=>nil, :id=>nil},
                :settlement_batch_id=>nil, :purchase_order_number=>nil,
                :shipping=>{:postal_code=>nil, :country_code_alpha3=>nil, :company=>nil, :first_name=>nil, :country_code_alpha2=>nil, :country_code_numeric=>nil, :last_name=>nil,
                            :street_address=>nil, :country_name=>nil, :locality=>nil, :region=>nil, :extended_address=>nil, :id=>nil},
                :gateway_rejection_reason=>nil,
                :status_history=>[
                        {:status=>"authorized", :transaction_source=>"API", :user=>status_history_user, :timestamp=>time, :amount=>amount},
                        {:status=>"submitted_for_settlement", :transaction_source=>"API", :user=>status_history_user, :timestamp=>time, :amount=>amount}],
                :subscription=>{:billing_period_end_date=>nil, :billing_period_start_date=>nil},
                :avs_error_response_code=>nil, :tax_amount=>nil, :amount=>amount, :add_ons=>[], :id=>transaction_id, :updated_at=>time,
                :avs_postal_code_response_code=>"I", :processor_authorization_code=>"7G57PT",
                :credit_card=>{:cardholder_name=>nil, :card_type=>"Visa", :last_4=>"0026", :expiration_month=>"05", :expiration_year=>"2012", :token=>nil, :customer_location=>"US", :bin=>"401200"},
                :discounts=>[], :custom_fields=>"\n  ", :tax_exempt=>false
               }
      }
    end

    def response_auth_capture_customer(hash)
      time = Time.now
      amount = hash[:amount]
      customer_id = hash[:customer_id]
      credit_card = hash[:payment_method_token]
      transaction_id = transaction_id_from_hash(hash)
      {:transaction=>
               {:customer=>{:company=>nil, :first_name=>"Jen", :last_name=>"Smith", :email=>nil, :phone=>nil, :id=>customer_id, :website=>nil, :fax=>nil},
                :refund_ids=>[], :type=>"sale", :cvv_response_code=>"I", :avs_street_address_response_code=>"M", :refund_id=>nil, :descriptor=>{:phone=>nil, :name=>nil},
                :status=>"submitted_for_settlement", :subscription_id=>nil, :refunded_transaction_id=>nil, :merchant_account_id=>merchant_account_id, :processor_response_code=>"1000",
                :currency_iso_code=>"USD", :created_at=>time, :order_id=>nil, :processor_response_text=>"Approved",
                :billing=>{
                        :postal_code=>"60622", :country_code_alpha3=>"USA", :company=>nil, :first_name=>"Jenna", :country_code_alpha2=>"US", :country_code_numeric=>"840", :last_name=>"Smith",
                        :street_address=>"1 E Main St", :country_name=>"United States of America", :locality=>"Chicago", :region=>"Illinois", :extended_address=>nil, :id=>"dm"},
                :settlement_batch_id=>nil, :purchase_order_number=>nil,
                :shipping=>{:postal_code=>nil, :country_code_alpha3=>nil, :company=>nil, :first_name=>nil, :country_code_alpha2=>nil, :country_code_numeric=>nil, :last_name=>nil,
                            :street_address=>nil, :country_name=>nil, :locality=>nil, :region=>nil, :extended_address=>nil, :id=>nil},
                :gateway_rejection_reason=>nil,
                :status_history=>[
                        {:status=>"authorized", :transaction_source=>"API", :user=>status_history_user, :timestamp=>time, :amount=>amount},
                        {:status=>"submitted_for_settlement", :transaction_source=>"API", :user=>status_history_user, :timestamp=>time, :amount=>amount}],
                :subscription=>{:billing_period_end_date=>nil, :billing_period_start_date=>nil},
                :avs_error_response_code=>nil, :tax_amount=>nil, :amount=>amount, :add_ons=>[], :id=>transaction_id, :updated_at=>time,
                :avs_postal_code_response_code=>"M", :processor_authorization_code=>"KZHZ38",
                :credit_card=>{:cardholder_name=>nil, :card_type=>"Visa", :last_4=>"0026", :expiration_month=>"12", :expiration_year=>"2012", :token=>credit_card, :customer_location=>"US", :bin=>"401200"},
                :discounts=>[], :custom_fields=>"\n  ", :tax_exempt=>false
               }
      }


    end
    
      
    
  end
end