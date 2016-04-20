# hook to coordinate blog posts and pages into distinct urls,
# and remove duplicate multilanguage posts and pages
Jekyll::Hooks.register :site, :post_read do |site|
  site.posts.docs = site.coordinate_documents(site.posts.docs)
  site.pages = site.coordinate_documents(site.pages)
end
