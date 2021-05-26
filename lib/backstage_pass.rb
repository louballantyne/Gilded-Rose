require_relative 'item_base'

class BackstagePass < ItemBase

  def decay
    return if item_quality_limit?
    if @sell_in >= 10
      @quality += 1
    elsif @sell_in.between?(6, 9)
      @quality += 2
    elsif @sell_in.between?(0, 5)
      @quality += 3
    else
      @quality = 0
    end
    @quality = 50 if @quality > 50
  end

end
