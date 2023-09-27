class Event
  attr_reader :name, :food_trucks

  def initialize(name)
    @name = name
    @food_trucks = []
  end

  def add_food_truck(food_truck)
    @food_trucks << food_truck
  end

  def food_truck_names
    @food_trucks.map do |food_truck|
      food_truck.name
    end
  end

  def food_trucks_that_sell(item)
    @food_trucks.find_all do |food_truck|
      food_truck.inventory.keys.include?(item)
    end
  end

  def overstocked_items

    overstock = []

    total_inventory.each do |item, item_details|
      if food_trucks_that_sell(item).length > 1 && item_details[:quantity] > 50
        overstock << item
      end
    end

    overstock
  end

  def sorted_item_list
    items = []
    @food_trucks.each do |food_truck|
      food_truck.inventory.each do |item, quantity|
        items << item.name
      end
    end
    items.uniq.sort
  end

  def total_inventory
   
    inventory = {}

    @food_trucks.each do |food_truck|
      food_truck.inventory.each do |item, quantity|
        inventory[item] = {
          quantity: get_item_quantity(item),
          food_trucks: food_trucks_that_sell(item)
        }
      end
    end

    inventory
  end

  def get_item_quantity(item)
    total = 0

    food_trucks_that_sell(item).each do |food_truck|
      total += food_truck.check_stock(item)
    end

    total
  end

end