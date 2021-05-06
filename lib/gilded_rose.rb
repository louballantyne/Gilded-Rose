class GildedRose

  def initialize(items)
    @items = items
  end

  def aged_brie(item)
    item.sell_in >= 0 ? item.quality += 1 : item.quality += 2
  end

  def backstage_pass(item)
    if item.sell_in >= 10
      item.quality += 1
    elsif item.sell_in >= 6
      item.quality += 2
    elsif item.sell_in >= 0
      item.quality += 3
    else
      item.quality = 0
    end
  end

  def other_objects(item)
    item.sell_in >= 0 ? item.quality -=1 : item.quality -= 2
  end

  def update_quality
    @items.each do |item|
      next if item.name == "Sulfuras, Hand of Ragnaros"
      item.sell_in -= 1
      next if item.quality > 50 || item.quality <= 0
      case item.name
      when "Aged Brie" then aged_brie(item)
      when "Backstage passes to a TAFKAL80ETC concert" then backstage_pass(item)
      else other_objects(item)
      end
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
