class CartsController < ApplicationController
  before_action :set_cart, only: %i[ show edit update destroy ]
  before_action :authenticate_user!

  # GET /carts or /carts.json
  def index
    @carts = Cart.all
  end

  # GET /carts/1 or /carts/1.json
  def show
  end

  # GET /carts/new
  def new
    @cart = Cart.new
  end

  # GET /carts/1/edit
  def edit
  end

  # POST /carts or /carts.json
  def create
  @cart = current_cart
  event = Event.find(params[:event_id])

  # Retrieve quantity from the form, defaulting to 1 if not provided
  quantity = params[:quantity].to_i
  quantity = 1 if quantity <= 0

  @line_item = @cart.line_items.find_by(event_id: event.id)

  if @line_item
    @line_item.quantity += quantity
  else
    @line_item = @cart.line_items.build(event: event, quantity: quantity)
  end

  respond_to do |format|
    if @line_item.save
      format.html { redirect_to cart_path(@cart), notice: "Added to cart successfully!" }
    else
      format.html { redirect_to events_path, alert: "Failed to add to cart." }
    end
  end
end


  # PATCH/PUT /carts/1 or /carts/1.json
  def update
    respond_to do |format|
      if @cart.update(cart_params)
        format.html { redirect_to @cart, notice: "Cart was successfully updated." }
        format.json { render :show, status: :ok, location: @cart }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @cart.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /carts/1 or /carts/1.json
  def destroy
    @cart.destroy!

    respond_to do |format|
      format.html { redirect_to carts_path, status: :see_other, notice: "Cart was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_cart
      @cart = Cart.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def cart_params
      params.fetch(:cart, {})
    end
end
