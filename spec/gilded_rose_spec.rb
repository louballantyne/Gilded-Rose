require 'gilded_rose'
require 'helper_methods'

describe GildedRose do
  describe "#update_quality" do
    it "does not change the name" do
      items = [Item.new("foo", 0, 0)]
      GildedRose.new(items).update_quality
      expect(items[0].name).to eq "foo"
    end
  end

  context 'when the sell-by date has passed, quality of most items degrades twice as fast' do
    vest = [Item.new("+5 Dexterity Vest", 10, 20)]
    shop = GildedRose.new(vest)
    it "dexterity vest quality that starts at 10 is 9 after 1 day, if sell-by date has not passed" do
      expect{ shop.update_quality }.to change { vest[0].quality }.by(-1)
    end

    it "dexterity vest quality decreases by 2 after 1 day, if sell-by date has passed" do
      9.times { shop.update_quality }
      expect{ shop.update_quality }.to change { vest[0].quality }.by(-2)
    end
  end

  context 'when brie ages, the quality increases' do
    brie = [Item.new("Aged Brie", 1, 20)]
    shop = GildedRose.new(brie)
    it "increases in quality by 1 each day until the sell-by date" do
      expect{ shop.update_quality }.to change { brie[0].quality }.by 1
    end

    it "increases in quality by 2 each day after the sell-by date" do
      expect{ shop.update_quality }.to change { brie[0].quality }.by 2
    end
  end

  context 'when sulfuras ages, the quality does not change' do
    it "quality does not change after 1 day" do
      sulfuras = [Item.new("Sulfuras, Hand of Ragnaros", 10, 20)]
      shop = GildedRose.new(sulfuras)
      expect{ shop.update_quality }.to change { sulfuras[0].quality }.by 0
    end
  end

  context 'sulfuras does not have to be sold' do
    it "quality does not decrease past sell-by date" do
      sulfuras = [Item.new("Sulfuras, Hand of Ragnaros", 10, 20)]
      shop = GildedRose.new(sulfuras)
      15.times { shop.update_quality }
      expect{ shop.update_quality }.to change { sulfuras[0].quality }.by 0
    end
  end

  context 'when approaching (but not surpassing) sell-by date, quality of backstage pass increases' do
    pass = [Item.new("Backstage passes to a TAFKAL80ETC concert", 11, 20)]
    shop = GildedRose.new(pass)
    it "quality increases by 1 after 1 day, if there are > 10 days to go (not past sell-by date)" do
      expect{ shop.update_quality }.to change { pass[0].quality }.by 1
    end

    it "quality increases by 2 after 1 day, if there are 10-6 days to go (not past sell-by date)" do
      expect{ shop.update_quality }.to change { pass[0].quality }.by 2
    end

    it "quality increases by 3 after 1 day, if there are < 6 days to go (not past sell-by date)" do
      5.times { shop.update_quality }
      expect{ shop.update_quality }.to change { pass[0].quality }.by 3
    end

    it "quality is 0 past sell-by date" do
      5.times { shop.update_quality }
      expect( pass[0].quality).to eq(0)
    end
  end

  describe 'quality is always between 0 and 50' do
    it "does not increase the quality of Aged Brie beyond 50" do
      brie = [Item.new("Aged Brie", 10, 50)]
      shop = GildedRose.new(brie)
      shop.update_quality
      expect{ shop.update_quality }.to change { brie[0].quality }.by 0
      expect( brie[0].quality ).to eq 50
    end

    it "does not decrease quality below 0" do
      vest = [Item.new("+5 Dexterity Vest", 10, 10)]
      shop = GildedRose.new(vest)
      20.times { shop.update_quality }
      expect(vest[0].quality).to eq(0)
    end
  end

  context 'with time, conjured items degrade in quality twice as quickly as other items' do
    cake = [Item.new(name = "Conjured Mana Cake", 1, 10)]
    shop = GildedRose.new(cake)
    it 'decreases in quality by 2 in a day, up until the sell-by date' do
      expect{ shop.update_quality }.to change { cake[0].quality }.by(-2)
    end

    it 'decreases in quality by 4 in a day, after the sell-by date' do
      expect{ shop.update_quality }.to change { cake[0].quality }.by(-4)
    end
  end

  context 'it prints out a list of items available' do
    items = items_method
    shop = GildedRose.new(items)
    it 'prints out a list of items with name, sellIn and quality' do
      expect { shop.print_items }.to output(/#{Regexp.quote(output_1)}/).to_stdout
    end
    it 'allows the user to specify a number of days to print' do
      expect { shop.print_items(3) }.to output(/#{Regexp.quote(output_2)}/).to_stdout
    end
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
# Conjured Mana Cake, 2, 4
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
# Conjured Mana Cake, 1, 2
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
# Conjured Mana Cake, 0, 0
#
