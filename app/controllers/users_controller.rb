class UsersController < ApplicationController

  before_action :current, only: [:user_account, :order_history, :manage_tours, :retail_history]

  def index
    @users = User.joins(:products).group('users.id')
  end

  def create
    auth_hash = request.env["omniauth.auth"]
    user = User.find_by(uid: auth_hash["uid"], provider: auth_hash["provider"])
    if user
      flash[:success] = "Welcome back #{user.username}!"
    else
      user = User.build_from_github(auth_hash)
      if user.save
        flash[:success] = "Logged in as new user #{user.username}."
      else
        flash[:error] = "Sorry, could not create new account #{user.errors.messages}"
        return redirect_to root_path
      end
    end

    session[:user_id] = user.id
    return redirect_to root_path
  end

  def destroy
    session[:user_id] = nil
    flash[:success] = "Logged out. See you next time!"
    return redirect_to root_path
  end

  def user_account
    if @current_user.payment_infos.nil? || @current_user.payment_infos == []
      @address = "No address saved"
    else
      @payment_infos = @current_user.payment_infos
      @address = @current_user.payment_infos.first.address
    end
    return
  end

  def order_history
    @orders = @current_user.orders
  end

  def retail_history
    @items = OrderItem.joins(:product).where(products: {user_id: @current_user.id})
  end

  def manage_tours
    @products = @current_user.products
  end

  def show
    @user = User.find_by(id: params[:id])
    if @user.nil?
      flash[:error] = "Can't find the guide."
      redirect_to root_path
      return
    end
    return
  end

  private

  def current
    @current_user = User.find_by(id: session[:user_id])
    unless @current_user
      flash[:error] = 'You must be logged in to see this page'
      redirect_to root_path
      return
    end
    return
  end

end
