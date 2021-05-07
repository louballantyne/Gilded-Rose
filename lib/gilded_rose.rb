class GildedRose
  def initialize(items)
    @items = items
    @day = 0
  end

  def update_quality
    @items.each do |item|
      next if item.name == "Sulfuras, Hand of Ragnaros"

      item.sell_in -= 1
      next if item.quality >= 50
      case item.name
      when "Aged Brie" then aged_brie(item)
      when "Backstage passes to a TAFKAL80ETC concert" then backstage_pass(item)
      when "Conjured Mana Cake" then conjured_mana(item)
      else other_objects(item)
      end
    end
    @day += 1
  end

  def aged_brie(item)
    item.quality = if item.sell_in >= 0
                     item.quality + 1
                   else
                     item.quality + 2
                   end
  end

  def backstage_pass(item)
    return if item_quality_limit?(item)
    if item.sell_in >= 10
      item.quality += 1
    elsif item.sell_in >= 6
      item.quality += 2
    elsif item.sell_in >= 0
      item.quality += 3
    else
      item.quality = 0
    end
    item.quality = 50 if item.quality > 50
  end

  def item_quality_limit?(item)
    item.quality <= 0
  end

  def other_objects(item)
    return if item_quality_limit?(item)
    item.quality = if item.sell_in >= 0
                     item.quality - 1
                   else
                     item.quality - 2
                   end
  end

  def conjured_mana(item)
    2.times { other_objects(item)    }
  end

  def print_items(days = 1)
    days.times do
      puts "-------- day #{@day} --------"
      puts "name, sellIn, quality"
      @items.each do |item|
        puts item
      end
      update_quality
    end
  end
end

class Item
  attr_accessor :name, :sell_in, :quality

  def initialize(name, sell_in, quality)
    @name = name
    @sell_in = sell_in
    @quality = quality
  end

  def to_s()
    "#{@name}, #{@sell_in}, #{@quality}"
  end
end
