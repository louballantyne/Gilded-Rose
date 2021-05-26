require_relative 'item_base'

class Conjured < ItemBase

  def update_item
    @sell_in -= 1

    2.times do
      next if @quality >= ITEM_QUALITY_MAX
      decay
    end
  end

end
