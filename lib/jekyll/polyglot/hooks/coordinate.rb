# hook to coordinate blog posts and pages into distinct urls,
# and remove duplicate multilanguage posts and pages
Jekyll::Hooks.register :site, :post_read do |site|
  hook_coordinate(site)
end

def hook_coordinate(site)
  # Copy the language specific data, by recursively merging it with the default data.
  # Favour active_lang first, then default_lang, then any non-language-specific data.
  # See: https://www.ruby-forum.com/topic/142809
  merger = proc { |_key, v1, v2| v1.is_a?(Hash) && v2.is_a?(Hash) ? v1.merge(v2, &merger) : v2 }

  # Try both exact case and normalized lookup for data files
  default_data_key = site.data.keys.find { |k| k.downcase == site.default_lang.downcase }
  if default_data_key && site.data.include?(default_data_key)
    site.data = site.data.merge(site.data[default_data_key], &merger)
  end

  active_data_key = site.data.keys.find { |k| k.downcase == site.active_lang.downcase }
  if active_data_key && site.data.include?(active_data_key)
    site.data = site.data.merge(site.data[active_data_key], &merger)
  end

  site.collections.each_value do |collection|
    collection.docs = site.coordinate_documents(collection.docs)
  end
  site.pages = site.coordinate_documents(site.pages)
end
