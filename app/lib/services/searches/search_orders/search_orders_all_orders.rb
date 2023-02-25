module SearchOrdersAllOrders

  def search_orders_all_orders(search_query)
    puts("B: SEARCHQUERY: " + search_query)
    #search_query = Order.search "#{search_query}", where: {archived: false}
    search_query = Order.unscoped.search "#{search_query}"
    results_arr = Array.new

     search_query.results.each do |result|
       results_arr << result.id
     end

     return Order.where(id: results_arr)
  end

end
