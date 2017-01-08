module Spree
  module Admin
    class IntroductionsController < ResourceController

      def show
      end

      def index
        @introductions = Spree::Introduction.all
        respond_with(@introductions) do |format|
          format.html
          format.json { render :json => json_data }
        end
      end

      def create
        @introduction = Spree::Introduction.new(introduction_params)
        if @introduction.save
          flash.now[:success] = flash_message_for(@introduction, :successfully_created)
          @introductions ||= Spree::Introduction.all
          render :index
        else
          render :new
        end

      end

      def update
        if @introduction.update_attributes(introduction_params)
          flash.now[:success] = Spree.t(:introduction_updated)
          @introductions ||= Spree::Introduction.all
          render :index
        else
          render :edit
        end
      end

      def destroy
        if @introduction.destroy
          flash.now[:success] = Spree.t(:introduction_destroy)
        end
        respond_with(@introduction) do |format|
          format.html { redirect_to admin_introduction_url }
          format.js  { render_js_for_destroy }
        end
      end

      private

      def introduction_params
        params.require(:introduction).permit(:title, :body)
      end
    end
  end
end
