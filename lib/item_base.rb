class ItemBase
  attr_accessor :name, :sell_in, :quality

  ITEM_QUALITY_MAX = 50
  ITEM_QUALITY_MIN = 0

  def initialize(name, sell_in, quality)
    @name = name
    @sell_in = sell_in
    @quality = quality
  end

  def to_s()
    "#{@name}, #{@sell_in}, #{@quality}"
  end

  def update_item
    @sell_in -= 1
    return if @quality >= ITEM_QUALITY_MAX
    decay
  end

  def item_quality_limit?
    @quality <= ITEM_QUALITY_MIN
  end

  def decay
    return if item_quality_limit?
    @quality = if @sell_in >= 0
                     @quality - 1
                   else
                     @quality - 2
                   end
  end

end
