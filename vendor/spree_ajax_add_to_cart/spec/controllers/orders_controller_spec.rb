require 'spec_helper'

describe Spree::OrdersController do
  let(:user)    { create(:user) }
  let(:variant) { create(:variant) }
  
  let(:order) do
    Spree::Order.new
  end

  before do
    controller.stub(try_spree_current_user: user)
  end

  context '#populate' do
    it 'should ajax post correctly' do
      spree_post :populate, format: :js, variant_id: variant.id, quantity: 1
      assert_response :success
    end
  end
end
