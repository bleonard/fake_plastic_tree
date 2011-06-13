require 'spec_helper'

describe FakePlasticTree::Gateway do

  def customer_id
    "customer_123"
  end
  def creditcard_id
    "card_456"
  end

  def create_customer
    result = FakePlasticTree::Gateway.create_customer(
                :id => customer_id,
                :first_name => "Jen",
                :last_name => "Smith")
  end

  def create_card
    create_customer
    FakePlasticTree::Gateway.create_card(
                :customer_id => customer_id,
                :token => creditcard_id,
                :number => "4012000033330026",
                :expiration_date => "12/2012",
                :cvv => "123",
                :billing_address => {
                  :first_name => "Jenna",
                  :last_name => "Smith",
                  :street_address => "1 E Main St",
                  :locality => "Chicago",
                  :region => "Illinois",
                  :postal_code => "60622",
                  :country_code_alpha2 => "US"})    
  end

  def create_auth(value)
    create_card
    FakePlasticTree::Gateway.auth_only(
                  :amount => "#{value}.00",
                  :customer_id => customer_id,
                  :payment_method_token => creditcard_id)
  end  

  describe ".auth_capture" do
    context "with no user" do
      it "should make the sale from the card" do
        result = FakePlasticTree::Gateway.auth_capture(
                  :amount => "1002.00",
                  :credit_card => {
                    :number => "4012000033330026",
                    :expiration_date => "05/12"
                  })
        result.should be_success
      end
    end

    context "with a user" do
      it "should make the sale to the card" do
        result = FakePlasticTree::Gateway.auth_capture(
                :amount => "1003.00",
                :customer_id => customer_id,
                :payment_method_token => creditcard_id)

        result.should be_success
      end
    end
  end

  describe ".auth_only" do
    it "should authorize the card" do
      result = create_auth(1001)
      result.should be_success
    end
  end

  describe ".prior_auth_capture" do
    it "should be able to capture less" do
      auth = create_auth(949)
      auth.should be_success
      result = FakePlasticTree::Gateway.prior_auth_capture(auth.transaction.id, "450.05")
      result.should be_success
    end
    it "should be able to capture" do
      auth = create_auth(950)
      auth.should be_success
      result = FakePlasticTree::Gateway.prior_auth_capture(auth.transaction.id, "950.00")
      result.should be_success
    end
    it "should not be able to capture more" do
      auth = create_auth(951)
      auth.should be_success
      result = FakePlasticTree::Gateway.prior_auth_capture(auth.transaction.id, "952.00")
      result.should_not be_success
    end
    it "should not be able to capture random" do
      lambda { result = FakePlasticTree::Gateway.prior_auth_capture("kjfhdfgkjh", "953.00") }.should raise_error(Braintree::BraintreeError)
    end
  end

  describe ".prior_auth_void" do
    it "should be able to void" do
      auth = create_auth(960)
      auth.should be_success
      result = FakePlasticTree::Gateway.prior_auth_void(auth.transaction.id)
      result.should be_success
    end
    it "should be able to void random" do
      lambda { FakePlasticTree::Gateway.prior_auth_void("lohfgfq") }.should raise_error(Braintree::BraintreeError)
    end
  end

  describe ".create_customer" do
    it "should be able to create a customer with an id" do
      result = create_customer
      result.should be_success
    end
  end

  describe ".create_card" do
    it "should be able to create a customer with an id" do
      result = create_card
      result.should be_success
    end
  end
end