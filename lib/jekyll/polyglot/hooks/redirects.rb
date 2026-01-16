# frozen_string_literal: true

# Hook to localize Netlify _redirects file for multilingual sites.
# When enabled, generates language-prefixed versions of each redirect.
#
# Configuration:
#   localize_redirects: true  # Enable the feature
#   exclude_from_redirect_localization:  # Optional: paths to skip
#     - /signin
#     - /app
#
# Example:
#   Input:  /github https://github.com/org/repo 302
#   Output: /github https://github.com/org/repo 302
#           /es/github https://github.com/org/repo 302
#           /de/github https://github.com/org/repo 302
#           ...

Jekyll::Hooks.register :polyglot, :post_write do |site|
  hook_redirects(site)
end

def hook_redirects(site)
  return unless site.config.fetch('localize_redirects', false)

  redirects_path = File.join(site.source, '_redirects')
  return unless File.exist?(redirects_path)

  exclusions = site.config.fetch('exclude_from_redirect_localization', [])
  lines = File.readlines(redirects_path)
  localized_lines = []

  lines.each do |line|
    # Always include the original line
    localized_lines << line

    # Skip comments and empty lines
    stripped = line.strip
    next if stripped.empty? || stripped.start_with?('#')

    # Parse the redirect line: /source /target [status_code]
    parts = stripped.split(/\s+/)
    next if parts.length < 2

    source = parts[0]

    # Skip if source is in exclusion list
    next if exclusions.include?(source)

    # Only process paths that start with /
    next unless source.start_with?('/')

    # Skip if source already has a language prefix
    next if site.languages.any? { |lang| source.start_with?("/#{lang}/") || source == "/#{lang}" }

    # Add localized versions for non-default languages
    site.languages.each do |lang|
      next if lang == site.default_lang

      localized_source = "/#{lang}#{source}"
      rest = parts[1..-1].join(' ')
      localized_lines << "#{localized_source} #{rest}\n"
    end
  end

  # Write to destination
  dest_path = File.join(site.dest, '_redirects')
  File.write(dest_path, localized_lines.join)
end
