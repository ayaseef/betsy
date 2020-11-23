class OrderItemsController < ApplicationController
  before_action :find_product, only: :create

  def new
    @order_item = OrderItem.new(order_item_params)
  end

  def create
    new_qty = params["quantity"].to_i
    new_item = params["product_id"]

    #is there an existing order? if not, create a new Order
    if session[:order_id] == nil || session[:order_id] == false
      @order = Order.new(status: "pending")
      session[:order_id] = @order.id
    else
      @order.find_by(id: session[:order_id])
    end

    if new_qty + @order.current_quantity(new_item) > Product.find(new_item).stock
      flash.now[:error] = "This item is low in stock. Can't update cart." #not added
      redirect_to order_path(session[:order_id])
      return
    end

    if @order.confirm_order_items(new_item, new_qty) == false
      @order.order_items << OrderItem.create(
          quantity: new_qty,
          product_id: new_item,
          order_id: @order.id
      )
      flash[:success] = "Cart updated." #item added
      redirect_to product_path(params["product_id"])
      return
    end
  end

  def update
    @order_item.quantity = params[:new_qty]
    @order_item.save
    flash[:success] = "Quantity updated"
    redirect_to order_path(session[:order_id])
  end

  def destroy
    @order_item = OrderItem.find(params[:id])
    @order_item.destroy
    flash.now[:status] = :success
    flash.now[:result_text] = "#{@order_item.product.name} removed from cart."
    if session[:order_id]
      redirect_to shopping_cart_path
    else
      redirect_to root_path
    end
  end

  def increase_qty
    if session[:order_id] == nil || session[:order_id] == false
      return "Your cart is empty. Please add some adventures to it."
    end

    @product = Product.find_by(id: )

    session[:order_id].each do |item|
      if item["product_id"] ==
    end


    end

    def decrease_qty

    end



  private

  def order_item_params
    return params.require(:order_item).permit(:quantity, :product_id, :order_id)
  end
  end




