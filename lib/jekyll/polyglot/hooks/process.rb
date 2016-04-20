# hook to make a call to process rendered documents,
Jekyll::Hooks.register :site, :post_render do |site|
  site.process_documents(site.posts.docs)
  site.process_documents(site.pages)
end
