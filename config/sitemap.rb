# Load Rails environment
SitemapGenerator::Sitemap.default_host = "https://www.bamsfx.com"

SitemapGenerator::Sitemap.public_path = "public/"
SitemapGenerator::Sitemap.sitemaps_host = "https://www.bamsfx.com"
SitemapGenerator::Sitemap.sitemaps_path = "sitemaps/"

SitemapGenerator::Sitemap.create do
  add root_path, priority: 1.0, changefreq: 'daily'
  add list_path, priority: 1.0, changefreq: 'daily'
  add collection_templates_path, priority: 1.0, changefreq: 'daily'
  add about_path, priority: 0.8, changefreq: 'monthly'
  add the_quest_path, priority: 0.8, changefreq: 'monthly'

  TemplateCollection.find_each do |collection|
    add collection_template_path(collection), lastmod: collection.updated_at, changefreq: 'weekly', priority: 0.8
  end

  SfxPack.find_each do |pack|
    add sfx_pack_path(pack), lastmod: pack.updated_at, changefreq: 'weekly', priority: 0.8
  end
end

SitemapGenerator::Sitemap.ping_search_engines
