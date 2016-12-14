# hook to coordinate blog posts and pages into distinct urls,
# and remove duplicate multilanguage posts and pages
Jekyll::Hooks.register :site, :post_read do |site|
  if site.data.include?(site.active_lang)
    site.data = site.data.merge(site.data[site.active_lang])
  end
  site.collections.each do |_, collection|
    collection.docs = site.coordinate_documents(collection.docs)
  end
  site.pages = site.coordinate_documents(site.pages)
end
