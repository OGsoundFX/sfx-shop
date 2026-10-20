class PackOrderJob < ApplicationJob
  queue_as :default

  def perform
    packs = SfxPack.live.where.not(id: 100).to_a.shuffle

    # SfxPack.transaction enforces the commit to the DB only at the end of the iteration if all individual updates pass, otherwise the whole process rolls back
    SfxPack.transaction do
      packs.each_with_index do |pack, index|
        pack.update!(display_order: index + 1)
      end
    end
  end
end
