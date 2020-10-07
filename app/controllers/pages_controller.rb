class PagesController < ApplicationController
  def home
    @designers = SoundDesigner.all
    @sfx_packs = SfxPack.all
  end
end
