require_relative 'item'

class GildedRose

  ITEM_QUALITY_MAX = 50
  ITEM_QUALITY_MIN = 0

  def initialize(items)
    @items = items
    @day = 0
  end

  def update_quality
    @items.each do |item|
      next if item.name == "Sulfuras, Hand of Ragnaros"

      item.sell_in -= 1
      next if item.quality >= ITEM_QUALITY_MAX
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
    case item.sell_in
    when 10..Float::INFINITY
      item.quality += 1
    when 6..9
      item.quality += 2
    when 0..5
      item.quality += 3
    else
      item.quality = 0
    end
    item.quality = 50 if item.quality > 50
  end

  def item_quality_limit?(item)
    item.quality <= ITEM_QUALITY_MIN
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
    2.times { other_objects(item) }
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
