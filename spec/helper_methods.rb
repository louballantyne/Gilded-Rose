require 'gilded_rose'

def create_vest
  vest = Item.new(name="+5 Dexterity Vest", sell_in=10, quality=10)
  shop = GildedRose.new(vest)
end
