# hook to make a call to process rendered documents,
Jekyll::Hooks.register :site, :pre_render do |site|
  hook_process(site)
end

def hook_process(site)
  enrich_payload(site)
end

def enrich_payload(site)
  site.payload['site']['default_lang'] = site.default_lang
  site.payload['site']['languages'] = site.languages
  site.payload['site']['active_lang'] = site.active_lang
  lang_vars.each do |v|
    site.payload['site'][v] = site.active_lang
  end
  site.payload
end
