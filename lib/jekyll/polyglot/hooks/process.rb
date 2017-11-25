# hook to make a call to process rendered documents,
Jekyll::Hooks.register :site, :post_render do |site|
  hook_process(site)
end

def hook_process(site)
  site.collections.each do |_, collection|
    process_documents(site, collection.docs)
  end
  process_documents(site, site.pages)
end

# performs any necesarry operations on the documents before rendering them
def process_documents(site, docs)
  return if site.active_lang == site.default_lang
  url = config.fetch('url', false)
  rel_regex = relative_url_regex(site)
  abs_regex = absolute_url_regex(site, url)
  docs.each do |doc|
    relativize_urls(doc, rel_regex)
    if url
    then relativize_absolute_urls(doc, abs_regex, url)
    end
  end
end

# a regex that matches relative urls in a html document
# matches href="baseurl/foo/bar-baz" and others like it
# avoids matching excluded files
def relative_url_regex(site)
  regex = ''
  (site.exclude + site.languages).each do |x|
    regex += "(?!#{x}\/)"
  end
  %r{href=\"?#{site.baseurl}\/((?:#{regex}[^,'\"\s\/?\.#]+\.?)*(?:\/[^\]\[\)\(\"\'\s]*)?)\"}
end

def absolute_url_regex(site, url)
  regex = ''
  (site.exclude + site.languages).each do |x|
    regex += "(?!#{x}\/)"
  end
  %r{href=\"?#{url}#{site.baseurl}\/((?:#{regex}[^,'\"\s\/?\.#]+\.?)*(?:\/[^\]\[\)\(\"\'\s]*)?)\"}
end

def relativize_urls(site, doc, regex)
  doc.output.gsub!(regex, "href=\"#{site.baseurl}/#{site.active_lang}/" + '\1"')
end

def relativize_absolute_urls(site, doc, regex, url)
  doc.output.gsub!(regex, "href=\"#{url}#{site.baseurl}/#{site.active_lang}/" + '\1"')
end
