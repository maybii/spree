module Spree
  # This is somewhat contrary to standard REST convention since there is not
  # actually a Checkout object. There's enough distinct logic specific to
  # checkout which has nothing to do with updating an order that this approach
  # is waranted.
  class IntroductionController < Spree::StoreController

    def index
      @introductions = Spree::Introduction.where('').order('created_at DESC')
    end

    def show
      @introduction = Spree::Introduction.find(params[:id])
    end
  end
end
