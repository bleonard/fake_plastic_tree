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

    def self.response_auth_only(hash)
      time = Time.now
      amount = hash[:amount]
      customer_id = hash[:customer_id]
      credit_card = hash[:payment_method_token]
      transaction_id = transaction_id_from_hash(hash)
      {:transaction=>
               {:customer=>{:company=>nil, :first_name=>"Jen", :last_name=>"Smith", :email=>nil, :phone=>nil, :id=>customer_id, :website=>nil, :fax=>nil},
                :refund_ids=>[], :type=>"sale", :cvv_response_code=>"I", :avs_street_address_response_code=>"M", :refund_id=>nil, :descriptor=>{:phone=>nil, :name=>nil},
                :status=>"authorized", :subscription_id=>nil, :refunded_transaction_id=>nil, :merchant_account_id=>merchant_account_id, :processor_response_code=>"1000",
                :currency_iso_code=>"USD", :created_at=>time, :order_id=>nil, :processor_response_text=>"Approved",
                :billing=>{
                        :postal_code=>"60622", :country_code_alpha3=>"USA", :company=>nil, :first_name=>"Jenna", :country_code_alpha2=>"US", :country_code_numeric=>"840", :last_name=>"Smith",
                        :street_address=>"1 E Main St", :country_name=>"United States of America", :locality=>"Chicago", :region=>"Illinois", :extended_address=>nil, :id=>"dm"},
                :settlement_batch_id=>nil, :purchase_order_number=>nil,
                :shipping=>{:postal_code=>nil, :country_code_alpha3=>nil, :company=>nil, :first_name=>nil, :country_code_alpha2=>nil, :country_code_numeric=>nil, :last_name=>nil,
                            :street_address=>nil, :country_name=>nil, :locality=>nil, :region=>nil, :extended_address=>nil, :id=>nil},
                :gateway_rejection_reason=>nil,
                :status_history=>[
                        {:status=>"authorized", :transaction_source=>"API", :user=>status_history_user, :timestamp=>time, :amount=>amount}],
                :subscription=>{:billing_period_end_date=>nil, :billing_period_start_date=>nil},
                :avs_error_response_code=>nil, :tax_amount=>nil, :amount=>amount, :add_ons=>[], :id=>transaction_id, :updated_at=>time,
                :avs_postal_code_response_code=>"M", :processor_authorization_code=>"YRT6GL",
                :credit_card=>{:cardholder_name=>nil, :card_type=>"Visa", :last_4=>"0026", :expiration_month=>"12", :expiration_year=>"2012", :token=>credit_card, :customer_location=>"US", :bin=>"401200"},
                :discounts=>[], :custom_fields=>"\n  ", :tax_exempt=>false
               }
      }
    end

    def self.response_auth_only_error(hash)
      time = Time.now
      amount = hash[:amount]
      customer_id = hash[:customer_id]
      credit_card = hash[:payment_method_token]
      transaction_id = transaction_id_from_hash(hash)
      
      {
              :api_error_response =>
                      {
                              :errors => {
                                      :errors => []
                              },
                              :message => "Processor Declined",
                              :transaction => {
                                      :subscription_id => nil,
                                      :type => "sale",
                                      :avs_postal_code_response_code => "M",
                                      :billing => {
                                              :country_code_alpha3 => "USA",
                                              :locality => nil,
                                              :first_name => "Jenna",
                                              :country_code_numeric => "840",
                                              :postal_code => "60622",
                                              :region => nil,
                                              :last_name => "Smith",
                                              :company => nil,
                                              :street_address => nil,
                                              :country_name => "United States of America",
                                              :country_code_alpha2 => "US",
                                              :id => "6c",
                                              :extended_address => nil
                                      },
                                      :status_history => [
                                              {
                                                      :status => "processor_declined",
                                                      :amount => amount,
                                                      :user => status_history_user,
                                                      :timestamp => time,
                                                      :transaction_source => "API"
                                              }
                                      ],
                                      :order_id => nil,
                                      :add_ons => [],
                                      :status => "processor_declined",
                                      :updated_at => time,
                                      :descriptor => {
                                              :phone => nil,
                                              :name => nil
                                      },
                                      :avs_street_address_response_code => "I",
                                      :discounts => [],
                                      :tax_amount => nil,
                                      :custom_fields => "\n    ",
                                      :amount => amount,
                                      :processor_authorization_code => nil,
                                      :merchant_account_id => merchant_account_id,
                                      :created_at => time,
                                      :tax_exempt => false,
                                      :refund_ids => [],
                                      :processor_response_code => "2500",
                                      :refund_id => nil,
                                      :processor_response_text => "Processor Declined",
                                      :purchase_order_number => nil,
                                      :refunded_transaction_id => nil,
                                      :credit_card=>{:cardholder_name=>nil, :card_type=>"Visa", :last_4=>"0026", :expiration_month=>"12", :expiration_year=>"2012", :token=>credit_card, :customer_location=>"US", :bin=>"401200"},
                                      :shipping=>{:postal_code=>nil, :country_code_alpha3=>nil, :company=>nil, :first_name=>nil, :country_code_alpha2=>nil, :country_code_numeric=>nil, :last_name=>nil,
                                                  :street_address=>nil, :country_name=>nil, :locality=>nil, :region=>nil, :extended_address=>nil, :id=>nil},
                                      :cvv_response_code => "I",
                                      :subscription=>{:billing_period_end_date=>nil, :billing_period_start_date=>nil},
                                      :customer=>{:company=>nil, :first_name=>"Jen", :last_name=>"Smith", :email=>nil, :phone=>nil, :id=>customer_id, :website=>nil, :fax=>nil},
                                      :id => transaction_id,
                                      :currency_iso_code => "USD",
                                      :avs_error_response_code => nil,
                                      :gateway_rejection_reason => "duplicate",
                                      :settlement_batch_id => nil
                              },
                              :params => {
                                      :transaction => {
                                              :type => "sale",
                                              :payment_method_token => credit_card,
                                              :options => {
                                                      :submit_for_settlement => "false"
                                              },
                                              :amount => amount,
                                              :customer_id => customer_id
                                      }
                              }
                      }
      }
    end


  end
end
