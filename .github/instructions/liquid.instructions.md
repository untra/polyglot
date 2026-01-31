---
applyTo: "lib/jekyll/polyglot/liquid.rb,lib/jekyll/polyglot/liquid/**/*.rb"
---

# Liquid Filters and Custom Tags Instructions

## Overview

The `liquid.rb` and `liquid/` directory define custom Liquid filters and tags for rendering language-aware content in Jekyll templates.

## Available Filters and Tags

- **`static_href` filter**: Relativizes URLs for multi-language sites
  - Used in templates: `{{ "/path/to/page" | static_href }}`
  - Must handle both absolute and relative URLs

- **`t` filter**: Translates strings in Liquid templates
  - Looks up translations from site data or frontmatter

- **`i18n_headers` tag**: Generates SEO hreflang links
  - Creates alternate language links for search engines

## When Adding/Modifying Filters

1. **Keep filters pure**: They should not modify global state or have side effects
2. **Handle edge cases**: Test with special characters, unicode, missing translations
3. **Document the filter**: Add comments explaining parameters and return values
4. **Write comprehensive tests**: Filters are used in templates; test all variations

## Testing Liquid Filters

Filters are tested in `spec/jekyll/polyglot/` with unit tests for individual filters and integration tests with Jekyll builds:

1. Add tests in `spec/jekyll/polyglot/liquid_spec.rb` (or create new file for new filters)
2. Test with special characters, unicode, and edge cases
3. Run filter tests: `bundle exec rspec spec/jekyll/polyglot/liquid_spec.rb`
4. Verify RuboCop compliance: `bundle exec rubocop lib/jekyll/polyglot/liquid.rb`
5. Integrate-test with fixture sites using `bash make.sh`

## Common Tasks

- **Adding a new filter**: Create a method in `liquid.rb`, register with Liquid::Template
- **Modifying URL relativization**: Changes to `static_href` must handle all Jekyll permalink styles
- **Adding translations**: Ensure fallback to default language if translation missing

## Testing URLs and Paths

When testing `static_href`:

- Test with absolute URLs (e.g., `/en/page/`)
- Test with relative URLs (e.g., `../page/`)
- Test with special characters in permalinks
- Test with different Jekyll permalink formats
- Verify output works correctly in multi-language builds
