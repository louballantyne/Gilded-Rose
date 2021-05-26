require_relative 'item_base'
class Item < ItemBase
  attr_accessor :name, :sell_in, :quality

  def self.new(name, sell_in, quality)
    case name
    when "Sulfuras, Hand of Ragnaros" then Sulfuras.new(name, sell_in, quality)
    when "Aged Brie" then AgedBrie.new(name, sell_in, quality)
    when "Backstage passes to a TAFKAL80ETC concert" then BackstagePass.new(name, sell_in, quality)
    when "Conjured Mana Cake" then ConjuredMana.new(name, sell_in, quality)
    else
      instance = allocate
      instance.send(:initialize, name, sell_in, quality)
      instance
    end
  end

end
