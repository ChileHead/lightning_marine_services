require 'faker'

desc 'Create Sample Orders'
task :create_orders => :environment do

  if Purchaser.last.nil?
    puts " "
    puts "*"*20
    puts " "
    puts "No purchasers in DB, Order must have a vendor to proceed, creating purchasers..."
    puts " "
    puts "*"*20
    puts " "

    rand(10..30).times do
        purchaser = Purchaser.create(name: Faker::Company.unique.name )
        puts " "
        puts "*"*20
        puts "#{purchaser} created."
        puts "*"*20
        puts "#{purchaser.inspect}"
        puts "*"*20
        puts " "
    end


    puts " "
    puts " "
    puts "*"*20
    puts "*"*20
    puts "*"*20
    puts " "
    puts "#{Purchaser.all.count} Purchasers created."
    puts " "
    puts "*"*20
    puts "*"*20
    puts "*"*20
    puts " "
    puts " "

  end

  if Vendor.last.nil?
    puts " "
    puts "*"*20
    puts " "
    puts "No vendors in DB, Order must have a vendor to proceed, creating vendors..."
    puts " "
    puts "*"*20
    puts " "

    rand(10..30).times do
        vendor = Vendor.create(name: Faker::Company.unique.name )
        puts " "
        puts "*"*20
        puts "#{vendor} created."
        puts "*"*20
        puts "#{vendor.inspect}"
        puts "*"*20
        puts " "
    end

    puts " "
    puts " "
    puts "*"*20
    puts "*"*20
    puts "*"*20
    puts " "
    puts "#{Vendor.all.count} Vendors created."
    puts " "
    puts "*"*20
    puts "*"*20
    puts "*"*20
    puts " "
    puts " "
  end

  start_ids_from = Order.last ? ( Order.last.id + 1) : 1
  random_order_count = rand(350..550)
  # random_order_count = rand(750..1500)

  puts " "
  puts "*"*20
  puts "Creating #{random_order_count} orders."
  puts "*"*20
  puts " "

  (start_ids_from..random_order_count).each do |id|

    order_class_false_or_nil = [true, false]
    archived_options = [true, false]

    order_delivery_date = Faker::Date.between(from: '2017-01-23', to: Time.now)

    order_recieval_date = Faker::Date.between(from: order_delivery_date.prev_month, to: order_delivery_date)

    order = Order.new(
      id: id,
      purchaser_id: "#{Purchaser.all.ids.sample}",
      vendor_id: "#{Vendor.all.ids.sample}",
      po_number: "#{Faker::Number.unique.within(range: 100..9999999999)}",
      courrier: "#{['Fedex', 'UPS', 'USPS', 'DHL'].sample}",
      date_recieved:"#{order_recieval_date.strftime("%Y-%m-%d")}",
      archived:  archived_options.sample
    )

    if [true, false].sample == true
      order.dept = "#{Faker::Job.field}"
    end

    if order.archived == true
      order.date_delivered = "#{order_delivery_date.strftime("%Y-%m-%d")}"
    end

    order.build_order_content(
      id: id,
      order_id: id,
      box: "#{rand(0..15)}",
      crate:"#{rand(0..20)}",
      pallet:"#{rand(0..10)}",
      other:"#{rand(0..5)}",
      other_description: 'test data'
    )

    order.save

    puts " "
    puts "*"*20
    puts "#{order} created."
    puts "*"*20
    puts "#{order.inspect}"
    puts "#{order.order_content.inspect}"
    puts "*"*20
    puts " "
  end

  puts " "
  puts " "
  puts "*"*20
  puts "*"*20
  puts "*"*20
  puts " "
  puts "#{Order.all.count} Orders created."
  puts " "
  puts "#{Order.unarchived.count} Unarchived Orders created."
  puts " "
  puts "#{Order.archived.count} Archived Orders created."
  puts " "
  puts "*"*20
  puts "*"*20
  puts "*"*20
  puts " "
  puts " "

  ActiveRecord::Base.connection.tables.each { |t| ActiveRecord::Base.connection.reset_pk_sequence!(t) }

  Order.reindex
  Purchaser.reindex
  Vendor.reindex

end
