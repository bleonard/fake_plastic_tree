module FakePlasticTree
  module CreateCustomer
    
    def create_customer(hash)
      response = response_create_customer(hash)
      customer_success(response)
    end
    
    protected
    
    def response_create_customer(hash)
      customer_id = customer_id_from_hash(hash)
      time = Time.now
      first_name = hash[:first_name] || "Jen"
      last_name = hash[:last_name] || "Smith"

      {:customer=>
               {:company=>nil, :first_name=>first_name, :created_at=>time, :last_name=>last_name, :addresses=>[], :email=>nil, :merchant_id=>merchant_id,
                :credit_cards=>[], :phone=>nil, :updated_at=>time, :id=>customer_id, :website=>nil, :custom_fields=>"\n  ", :fax=>nil
               }
      }
    end
    
  end
end
