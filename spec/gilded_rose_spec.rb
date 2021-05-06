require 'gilded_rose'
require 'helper_methods'

describe GildedRose do

  describe "#update_quality" do
    it "does not change the name" do
      items = [Item.new("foo", 0, 0)]
      GildedRose.new(items).update_quality
      expect(items[0].name).to eq "foo"
    end
context 'quality of most items degrades twice as fast once the sell-by date has passed' do
  it "dexterity vest quality that starts at 10 is 9 after 1 day, if sell-by date has not passed" do
    vest = [Item.new(name="+5 Dexterity Vest", sell_in=10, quality=10)]
    shop = GildedRose.new(vest)
    expect{ shop.update_quality }.to change { vest[0].quality }.by -1
  end
  it "dexterity vest quality decreases by 2 after 1 day, if sell-by date has passed" do
    vest = [Item.new(name="+5 Dexterity Vest", sell_in=10, quality=20)]
    shop = GildedRose.new(vest)
    10.times { shop.update_quality }
    expect{ shop.update_quality }.to change { vest[0].quality }.by -2
  end
end
context 'quality of brie increases as it ages' do
  it "increases in quality by 1 each day" do
    brie = [Item.new(name="Aged Brie", sell_in=10, quality=20)]
    shop = GildedRose.new(brie)
    expect{ shop.update_quality }.to change { brie[0].quality }.by 1
  end
end
context 'quality of sulfuras does not change as it ages' do
  it "quality does not change after 1 day" do
    sulfuras = [Item.new(name="Sulfuras, Hand of Ragnaros", sell_in=10, quality=20)]
    shop = GildedRose.new(sulfuras)
    expect{ shop.update_quality }.to change { sulfuras[0].quality }.by 0
  end
end
context 'sulfuras does not have to be sold' do
  it "quality does not decrease past sell-by date" do
    sulfuras = [Item.new(name="Sulfuras, Hand of Ragnaros", sell_in=10, quality=20)]
    shop = GildedRose.new(sulfuras)
    15.times { shop.update_quality }
    expect{ shop.update_quality }.to change { sulfuras[0].quality }.by 0
  end
end
context 'quality of backstage pass increases as it approaches (but does not surpass) sell-by date' do
  it "quality increases by 1 after 1 day, if there are > 10 days to go (not past sell-by date)" do
    pass = [Item.new(name="Backstage passes to a TAFKAL80ETC concert", sell_in=11, quality=20)]
    shop = GildedRose.new(pass)
    expect{ shop.update_quality }.to change { pass[0].quality }.by 1
  end
  it "quality increases by 2 after 1 day, if there are 10-6 days to go (not past sell-by date)" do
    pass = [Item.new(name="Backstage passes to a TAFKAL80ETC concert", sell_in=10, quality=20)]
    shop = GildedRose.new(pass)
    expect{ shop.update_quality }.to change { pass[0].quality }.by 2
  end
  it "quality increases by 3 after 1 day, if there are < 6 days to go (not past sell-by date)" do
    pass = [Item.new(name="Backstage passes to a TAFKAL80ETC concert", sell_in=5, quality=20)]
    shop = GildedRose.new(pass)
    expect{ shop.update_quality }.to change { pass[0].quality }.by 3
  end
  it "quality is 0 past sell-by date" do
    pass = [Item.new(name="Backstage passes to a TAFKAL80ETC concert", sell_in=2, quality=20)]
    shop = GildedRose.new(pass)
    3.times { shop.update_quality }
    expect( pass[0].quality).to eq(0)
  end
context
# quality is never negative
# quality never exceeds 50
# sulfuras does not have to be sold

end


# The Quality of an item is never negative
# The Quality of an item is never more than 50
# “Sulfuras”, being a legendary item, never has to be sold
  end

end


# example output:
# -------- day 0 --------
# name, sellIn, quality
# +5 Dexterity Vest, 10, 20
# Aged Brie, 2, 0
# Elixir of the Mongoose, 5, 7
# Sulfuras, Hand of Ragnaros, 0, 80
# Sulfuras, Hand of Ragnaros, -1, 80
# Backstage passes to a TAFKAL80ETC concert, 15, 20
# Backstage passes to a TAFKAL80ETC concert, 10, 49
# Backstage passes to a TAFKAL80ETC concert, 5, 49
# Conjured Mana Cake, 3, 6
#
# -------- day 1 --------
# name, sellIn, quality
# +5 Dexterity Vest, 9, 19
# Aged Brie, 1, 1
# Elixir of the Mongoose, 4, 6
# Sulfuras, Hand of Ragnaros, 0, 80
# Sulfuras, Hand of Ragnaros, -1, 80
# Backstage passes to a TAFKAL80ETC concert, 14, 21
# Backstage passes to a TAFKAL80ETC concert, 9, 50
# Backstage passes to a TAFKAL80ETC concert, 4, 50
# Conjured Mana Cake, 2, 5
#
# -------- day 2 --------
# name, sellIn, quality
# +5 Dexterity Vest, 8, 18
# Aged Brie, 0, 2
# Elixir of the Mongoose, 3, 5
# Sulfuras, Hand of Ragnaros, 0, 80
# Sulfuras, Hand of Ragnaros, -1, 80
# Backstage passes to a TAFKAL80ETC concert, 13, 22
# Backstage passes to a TAFKAL80ETC concert, 8, 50
# Backstage passes to a TAFKAL80ETC concert, 3, 50
# Conjured Mana Cake, 1, 4
#
# -------- day 3 --------
# name, sellIn, quality
# +5 Dexterity Vest, 7, 17
# Aged Brie, -1, 4
# Elixir of the Mongoose, 2, 4
# Sulfuras, Hand of Ragnaros, 0, 80
# Sulfuras, Hand of Ragnaros, -1, 80
# Backstage passes to a TAFKAL80ETC concert, 12, 23
# Backstage passes to a TAFKAL80ETC concert, 7, 50
# Backstage passes to a TAFKAL80ETC concert, 2, 50
# Conjured Mana Cake, 0, 3
#
# -------- day 4 --------
# name, sellIn, quality
# +5 Dexterity Vest, 6, 16
# Aged Brie, -2, 6
# Elixir of the Mongoose, 1, 3
# Sulfuras, Hand of Ragnaros, 0, 80
# Sulfuras, Hand of Ragnaros, -1, 80
# Backstage passes to a TAFKAL80ETC concert, 11, 24
# Backstage passes to a TAFKAL80ETC concert, 6, 50
# Backstage passes to a TAFKAL80ETC concert, 1, 50
# Conjured Mana Cake, -1, 1
