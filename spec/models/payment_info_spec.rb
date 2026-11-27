require 'rails_helper'

RSpec.describe PaymentInfo, type: :model do
  it 'accepts a valid PayPal email address' do
    payment_info = described_class.new(paypal_account: 'designer+payments@example.co.uk')
    payment_info.valid?

    expect(payment_info.errors[:paypal_account]).to be_empty
  end

  it 'rejects an invalid PayPal email address' do
    payment_info = described_class.new(paypal_account: 'not-an-email')
    payment_info.valid?

    expect(payment_info.errors[:paypal_account]).to include('must be a valid email address')
  end
end
