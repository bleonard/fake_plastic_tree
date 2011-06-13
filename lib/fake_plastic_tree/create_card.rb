module FakePlasticTree
  module CreateCard

    def create_card(hash)
      response = response_create_card(hash)
      card_success(response)
    end
    
    protected
    
    def response_create_card(hash)
      time = Time.now

      credit_card = credit_card_from_hash(hash)
      customer_id = hash[:customer_id]

      {:credit_card=>
               {:cardholder_name=>nil, :card_type=>"Visa", :last_4=>"0026", :expired=>false,
                :billing_address=>
                        {:postal_code=>"60622", :country_code_alpha3=>"USA", :company=>nil, :first_name=>"Jenna", :country_code_alpha2=>"US", :country_code_numeric=>"840",
                         :created_at=>time, :customer_id=>customer_id, :last_name=>"Smith", :street_address=>"1 E Main St", :locality=>"Chicago",
                         :country_name=>"United States of America", :id=>"dm", :region=>"Illinois", :extended_address=>nil, :updated_at=>time
                        },
                :created_at=>time, :expiration_month=>"12", :customer_id=>customer_id, :subscriptions=>[], :expiration_year=>"2012",
                :default=>true, :token=>credit_card, :customer_location=>"US", :updated_at=>time, :bin=>"401200"
               }
      }
    end

  end
end