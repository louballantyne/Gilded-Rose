require_relative 'item_base'

class AgedBrie < ItemBase

  def decay
    @quality = if @sell_in >= 0
                   @quality + 1
                 else
                   @quality + 2
                 end
  end
end
