# Load Rails environment
SitemapGenerator::Sitemap.default_host = "https://www.bamsfx.com"

SitemapGenerator::Sitemap.public_path = "public/"
SitemapGenerator::Sitemap.sitemaps_host = "https://www.bamsfx.com"
SitemapGenerator::Sitemap.sitemaps_path = "sitemaps/"

SitemapGenerator::Sitemap.create do
  add root_path, priority: 1.0, changefreq: 'daily'
  add list_path, priority: 1.0, changefreq: 'daily'
  add sfx_packs_path, priority: 1.0, changefreq: 'daily'
  add collection_templates_path, priority: 1.0, changefreq: 'daily'
  add pack_builder_path, priority: 1.0, changefreq: 'daily'
  add about_path, priority: 0.8, changefreq: 'monthly'
  add blog_path, priority: 0.8, changefreq: 'monthly'
  add the_quest_path, priority: 0.8, changefreq: 'monthly'

  TemplateCollection.where(active: true).find_each do |collection|
    add collection_template_path(collection), lastmod: collection.updated_at, changefreq: 'weekly', priority: 0.8
  end

  SfxPack.live.find_each do |pack|
    add sfx_pack_path(pack), lastmod: pack.updated_at, changefreq: 'weekly', priority: 0.8
  end
end
