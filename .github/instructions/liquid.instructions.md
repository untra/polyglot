---
applyTo: "lib/jekyll/polyglot/liquid.rb,lib/jekyll/polyglot/liquid/**/*.rb"
---

# Liquid Filters and Custom Tags Instructions

## Overview

The `liquid.rb` and `liquid/` directory define custom Liquid filters and tags for rendering language-aware content in Jekyll templates.

## Available Filters and Tags

- **`static_href` tag**: Relativizes URLs for multi-language sites
  - Used in templates: `{% static_href %}href="/path/to/page"{% endstatic_href %}`
  - Must handle both absolute and relative URLs

- **`i18n_headers` tag**: Generates SEO hreflang links
  - Creates alternate language links for search engines

## When Adding/Modifying Filters

1. **Keep filters pure**: They should not modify global state or have side effects
2. **Handle edge cases**: Test with special characters, unicode, missing translations
3. **Document the filter**: Add comments explaining parameters and return values
4. **Write comprehensive tests**: Filters are used in templates; test all variations

## Filter Implementation Details

**Filter Structure:**

- Filters are methods in a Ruby module (multiple filters can share a module)
- Method name becomes the filter name (no name mapping needed)
- First parameter is always the input value; additional parameters come after
- Return value is the filter's output

**Registration:**

- Use `Liquid::Template.register_filter(ModuleName)` to globally register a filter
- Filters are registered once when the plugin loads
- Multiple filters can be registered from the same module

**Accessing Context:**

- Filters can access Jekyll configuration via `@context.registers[:site]`
- Use `@context.registers[:site].config` to read `_config.yml` values
- The context object is available as the last parameter if needed (advanced usage)

**Example filter structure:**

```ruby
module Jekyll
  module Polyglot
    module Filters
      def static_href(input)
        # First parameter is always the input value
        # Method name "static_href" becomes the filter name
        # Return the processed value
        process_url(input)
      end
    end
  end
end

Liquid::Template.register_filter(Jekyll::Polyglot::Filters)
```

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

## Tags vs. Filters

**Filters** (used in output):

- Syntax: `{{ value | filter_name }}`
- Simple methods that transform a value
- Take input, return output
- Fast and stateless

**Tags** (block elements):

- Syntax: `{% tag_name args %}...{% endtag_name %}`
- Inherit from `Liquid::Tag` or `Liquid::Block`
- Can contain conditional logic or block content
- Require `initialize`, `render` methods
- Register with `Liquid::Template.register_tag`

Polyglot's `i18n_headers` is a **tag** because it generates complex SEO markup and may contain multiple blocks. If you're adding simple value transformations, use a **filter**.

## Testing URLs and Paths

When testing `static_href`:

- Test with absolute URLs (e.g., `/en/page/`)
- Test with relative URLs (e.g., `../page/`)
- Test with special characters in permalinks
- Test with different Jekyll permalink formats
- Verify output works correctly in multi-language builds
