# hook to make a call to process rendered documents,
Jekyll::Hooks.register :site, :after_reset do |site|
  puts('hook processS!!!!')
  hook_prepare(site)
  hook_process(site)
end

def hook_prepare(site)
  site.file_langs = {}
  fetch_languages(site)
  site.parallel_localization = site.config.fetch('parallel_localization', true)
  site.exclude_from_localization = site.config.fetch('exclude_from_localization', [])
end

def fetch_languages(site)
  site.default_lang = site.config.fetch('default_lang', 'en')
  site.languages = site.config.fetch('languages', ['en'])
  site.keep_files += (site.languages - [site.default_lang])
  site.active_lang = site.default_lang
  site.lang_vars = site.config.fetch('lang_vars', [])
end

def hook_process(site)
  all_langs = (site.languages + [site.default_lang]).uniq
  pids = {}
  all_langs.each do |lang|
    pids[lang] = fork do
      process_language lang
    end
  end
  Signal.trap('INT') do
    all_langs.each do |lang|
      puts "Killing #{pids[lang]} : #{lang}"
      kill('INT', pids[lang])
    end
  end
  all_langs.each do |lang|
    waitpid pids[lang]
    detach pids[lang]
  end
end

def process_language(site, lang)
  site.active_lang = lang
  site.config['active_lang'] = site.active_lang
  lang_vars.each do |v|
    site.config[v] = site.active_lang
  end
  if site.active_lang == site.default_lang
  then process_default_language(site)
  else process_active_language(site)
  end
end

def process_default_language(site)
  old_include = site.include
  process_orig
  site.include = old_include
end

def process_active_language(site)
  old_dest = site.dest
  old_exclude = site.exclude
  site.file_langs = {}
  site.dest = site.dest + '/' + site.active_lang
  site.exclude += site.exclude_from_localization
  process_orig
  site.dest = old_dest
  site.exclude = old_exclude
end
