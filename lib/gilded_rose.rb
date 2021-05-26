require_relative 'item'
require_relative 'item_base'
require_relative 'aged_brie'
require_relative 'backstage_pass'
require_relative 'conjured_mana'
require_relative 'conjured'
require_relative 'sulfuras'

class GildedRose

  ITEM_QUALITY_MAX = 50
  ITEM_QUALITY_MIN = 0

  def initialize(items)
    @items = items
    @day = 0
  end

  def update_quality
    @items.each do |item|
      item.update_item
    end
    @day += 1
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
