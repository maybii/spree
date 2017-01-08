module Spree
  module Admin
    class NoticesController < ResourceController

      def show
      end

      def index
        @notices = Spree::Notice.all
        respond_with(@notices) do |format|
          format.html
          format.json { render :json => json_data }
        end
      end

      def create
        @notice = Spree::Notice.new(notice_params)
        if @notice.save
          flash.now[:success] = flash_message_for(@notice, :successfully_created)
          @notices ||= Spree::Notice.all
          render :index
        else
          render :new
        end

      end

      def update
        if @notice.update_attributes(notice_params)
          flash.now[:success] = Spree.t(:notice_updated)
          @notices ||= Spree::Notice.all
          render :index
        else
          render :edit
        end
      end

      def destroy
        if @notice.destroy
          flash.now[:success] = Spree.t(:notice_destroy)
        end
        respond_with(@notice) do |format|
          format.html { redirect_to admin_notice_url }
          format.js  { render_js_for_destroy }
        end
      end

      private

      def notice_params
        params.require(:notice).permit(:title, :body)
      end
    end
  end
end
