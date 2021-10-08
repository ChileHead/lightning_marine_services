class OrdersController < ApplicationController
  before_action :authenticate_user!
  before_action :authenticate_admin, only: %i[ destroy ]
  before_action :set_order, only: %i[ show destroy ]
  before_action :set_pagination_params, only: %i[ index all_orders ]
  helper_method :sort_option, :sort_direction

  def all_orders
    autoload :OrdersSortTableLogic, "orders/sort_logic/orders_sort_table_logic.rb"
    @sorted_orders = OrdersSortTableLogic.sorted_orders(sort_option, sort_direction)
    @orders = BusinessLogicPagination.new(@sorted_orders, @per_page, @page)
    @initialize_table_options = BusinessLogicTableOption.new(current_user, 'Order')

    @order = Order.new
    @order_content = @order != nil ? @order.build_order_content : OrderContent.new

  end

  def index
    ############ Before
    # autoload :OrdersSortTableLogic, "orders/sort_logic/orders_sort_table_logic.rb"
    # @order = Order.new
    # @order_content = @order != nil ? @order.build_order_content : OrderContent.new
    # @sorted_orders = OrdersSortTableLogic.sorted_orders(sort_option, sort_direction)
    # @orders = BusinessLogicPagination.new(@sorted_orders.unarchived, @per_page, @page)
    # @initialize_table_options = BusinessLogicTableOption.new(current_user, 'Order')

    ############ Before Resource Parent
    # @orders_main = Order.all.unarchived
    # @initialize_table_options = ResourceTableOption.new(current_user, 'Order', 'index')
    # @orders = ResourcePagination.new(@sorted_orders.resource.unarchived, @per_page, @page)

    ############ After Resource Parent
    # autoload :InitResourceKlass, "resources/init_resource.rb"
    # autoload :InitResource, "resources/init_resource.rb"

    ####################################################
    autoload :Resource, "resources/resource.rb"
    ####################################################
    autoload :ServiceManager, "service_managers/service_manager.rb"
    ####################################################
    autoload :ResourceManagerTableOption, "resources/resource_managers/resource_manager_table_options/resource_manager_table_option.rb"
    ####################################################
    autoload :ResourceManagerPagination, "resources/resource_managers/resource_manager_paginations/resource_manager_pagination.rb"
    ####################################################
    autoload :ResourceManagerSort, "resources/resource_managers/resource_manager_sorts/resource_manager_sort.rb"
    ####################################################


     klass_attrs = {
      user: current_user,
      target: Order.all,
      parent_class: Order,
      parent_action: 'index',
      sort_option: sort_option,
      sort_direction: sort_direction,
      page: @page
    }

    @resource = Resource.new_resource_struct ( klass_attrs ) # Resource Data Object

    init_service_manager = ServiceManager.init_service_manager( klass_attrs ) # method extended from ServiceManagerCore (Sets ivars)

    ServiceManagerResourceTableOption::ResourceHasTableOption.new.is_satisfied_by?(@resource)

    ServiceManagerResourceSort::ResourceSortDirection.new.is_satisfied_by?(@resource)

    ServiceManagerResourcePagination::ResourcePagination.new.is_satisfied_by?(@resource)

    spec =
    ServiceManager::Composite.new(ServiceManagerResourceTableOption::ResourceHasTableOption)
    .and(ServiceManagerResourcePagination::ResourcePagination)
    .and(ServiceManagerResourceSort::ResourceSortDirection)

    spec.is_satisfied_by?(@resource)

    ####################################################
    ####################################################
    # byebug ####### ***********************************

    # @orders = Order.all

    @table_option_klass = ResourceManagerTableOption.new_table_option(user = @resource.user, parent_class = @resource.parent_class, action = @resource.parent_action, page = @resource.page)

    @sort_orders_klass = ResourceManagerSort.new_sort(resource = @resource, target = @resource.target, sort_option = @resource.sort_option, sort_direction = @resource.sort_direction)

    @pagination_klass = ResourceManagerPagination.new_pagination(resource = @resource.target, per_page = @table_option_klass.resources_per_page, page = @page)

    @orders = @sort_orders_klass.sort_resource

    # byebug ####### *********************************
    ####################################################
    ####################################################

    @order = Order.new
    @order_content = @order != nil ? @order.build_order_content : OrderContent.new

    respond_to do |format|
      format.html
      # Donwnload Orders link in app/views/orders/_export_csv_button.html.erb, if link is clicked will be formatted through here
      format.csv {
        send_data @orders.resource.to_csv,
        filename: "Orders-#{(DateTime.now).try(:strftime,"%m/%d/%Y") }.csv",
        type: 'text/csv; charset=utf-8'
      }
      format.xls {
        send_data (Order.all).to_csv,
        filename: "LightningMarineServices_Orders-#{(DateTime.now).try(:strftime,"%m/%d/%Y") }.xls"
      }
    end
  end


  # GET /orders/1 or /orders/1.json
  def show
    @new_order = Order.new
    order ||= @order
    @new_order_content = @new_order != nil ? @new_order.build_order_content : OrderContent.new
  end

  # GET /orders/new
  def new
    @order = Order.new
    # @order.order_content.build
    # @order.order_content.new
  end

  # GET /orders/1/edit
  def edit
    @order = Order.find(params[:id])
    @order.build_order_content if @order.order_content.nil?
  end

  def create
    @order = Order.new order_params
    @order_content = @order.order_content
    # byebug
    if @order.save
      redirect_to order_path(@order), notice: "Order Created Successfully."
    else
      redirect_to request.referrer
      @order.errors.each do |error|
        flash[:alert] = @order.errors.full_messages.map {|message| message}
      end
    end
  end

  def update
    @order = Order.find(params[:id])
    if @order.update(order_params)
      redirect_to request.referrer, notice: "Order Updated Successfully."
    else
      redirect_to request.referrer
      @order.errors.each do |error|
        flash[:alert] = @order.errors.full_messages.map {|message| message}
      end
    end
  end

  # DELETE /orders/1 or /orders/1.json
  def destroy
    @order.destroy
    respond_to do |format|
      format.html { redirect_to orders_url, notice: "Order deleted successfully." }
      format.json { head :no_content }
    end
  end

  def destroy_attachment
    # byebug
    # image = ActiveStorage::Attachment.find(params[:id])
    image.purge
    redirect_to request.referrer, notice: "Image deleted successfully."
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_order
      @order = Order.find(params[:id])
      @order_content = @order.order_content
    end

    def order_params
      params.require(:order).permit(:id, :purchaser_id, :vendor_id, :dept, :po_number, :date_recieved, :courrier, :date_delivered, images: [], order_content_attributes: [ :id, :box, :crate, :pallet, :other, :other_description])
    end

    def sort_option(sort_option = nil)
      sort_option = params[:sort_option] ||= nil
      return sort_option.to_s
    end

    def sort_direction(sort_direction = nil)
      sort_direction = params[:sort_direction] == "desc" ? "asc" : "desc"
    end

    def set_pagination_params
      # @per_page = 10
      @page = params.fetch(:page, 0).to_i
    end

end
