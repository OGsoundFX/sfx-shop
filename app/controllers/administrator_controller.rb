class AdministratorController < ApplicationController
  def admin
    redirect_to root_path if current_user.nil? || current_user.email != 'olivier@ogsoundfx.com'
    @all_sales = Sale.all
    @current_sales = Sale.where("end_date > ?", Date.current)
    @sale = Sale.last

    pack_hash = {
      "Monster SFX Pack" => 0,
      "Guns and Explosions"=> 0,
      "Outdoor Atmospheres"=> 0,
      "Underground Atmospheres"=> 0,
      "Natural Disasters"=> 0,
      "Ghost & Haunted"=> 0,
      "Weather Effects"=> 0
    }
    Order.where(status: "paid").each do |order|
      if order.multiple
        order.packs.each do |pack|
          pack_hash[SfxPack.find(pack).title] += 1
        end
      else
        pack_hash[SfxPack.find(order.sfx_pack_id).title] += 1
      end
    end
    @packs = pack_hash.sort_by {|_key, value| -value}.to_h
  end
end
