class LineItemsController < ApplicationController
  before_action :set_line_item, only: %i[ show edit update destroy ]

  # GET /line_items or /line_items.json
  def index
    @line_items = LineItem.all
  end

  # GET /line_items/1 or /line_items/1.json
  def show
  end

  # GET /line_items/new
  def new
    @line_item = LineItem.new
  end

  # GET /line_items/1/edit
  def edit
  end

  # POST /line_items or /line_items.json

  def create
    @cart = current_cart
    event = Event.find(params[:event_id])
  
    # Ensure the quantity is properly received from params
    quantity = params[:quantity].present? ? params[:quantity].to_i : 1
  
    # Find existing line_item or create a new one
    @line_item = @cart.line_items.find_or_initialize_by(event_id: event.id)
  
    # Update the quantity correctly
    @line_item.quantity += quantity if @line_item.persisted?
    @line_item.quantity = quantity unless @line_item.persisted?
  
    respond_to do |format|
      if @line_item.save
        format.html { redirect_to cart_path(@cart), notice: "Added to cart successfully!" }
      else
        format.html { redirect_to events_path, alert: "Failed to add to cart." }
      end
    end
  end
  
  
  


  # PATCH/PUT /line_items/1 or /line_items/1.json
  def update
    respond_to do |format|
      if @line_item.update(line_item_params)
        format.html { redirect_to @line_item, notice: "Line item was successfully updated." }
        format.json { render :show, status: :ok, location: @line_item }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @line_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /line_items/1 or /line_items/1.json
  def destroy
    @line_item.destroy!

    respond_to do |format|
      format.html { redirect_to line_items_path, status: :see_other, notice: "Line item was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_line_item
      @line_item = LineItem.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def line_item_params
      params.require(:line_item).permit(:cart_id, :store_id, :quantity)
    end
end
