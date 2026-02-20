# Architecture and Design Patterns

## Plugin Integration Overview

jekyll-polyglot integrates with Jekyll through three main mechanisms: hooks, patches, and Liquid filters. These work together to add i18n capabilities without breaking existing Jekyll functionality.

## Hooks System

**Location**: `lib/jekyll/polyglot/hooks.rb` and `lib/jekyll/polyglot/hooks/`

The plugin uses Jekyll's hook system to intercept the build process:

- **`post_init` hook**: Runs after Jekyll initializes, sets up configuration and language mappings
- **Other hooks**: Handle document coordinate setup, output relocation, and build orchestration
- **Execution mode**: Hooks run serially or in parallel based on the `parallel_localization` config setting

## Patches System

**Location**: `lib/jekyll/polyglot/patches.rb`

Patches extend Jekyll core classes with i18n capabilities:

- **Target classes**: `Jekyll::Document`, `Jekyll::Site`, and related classes
- **Methods added**: Language detection, document grouping, URL relativization
- **Design principle**: Only add methods; avoid overriding existing behavior without thorough testing
- **Application**: Patches are applied at require time

## Liquid Filters and Tags

**Location**: `lib/jekyll/polyglot/liquid.rb`

Custom Liquid filters and tags for rendering language-aware content in templates:

- **`static_href` tag**: Relativizes URLs for multi-language sites
- **`i18n_headers` tag**: Generates SEO hreflang links for alternate language versions

## Document Coordination Model

The core of polyglot's i18n support:

- Documents are grouped by **permalink** (or `page_id` in v1.7.0+)
- Each document declares its language via the `lang` frontmatter property
- The plugin "coordinates" documents with identical permalinks across languages
- **Alternative URLs per language**: Use `page_id` to identify translations when different URLs are needed per language (e.g., `/about` in English, `/acerca-de/` in Spanish)

## Configuration

Users configure polyglot in `_config.yml`:

```yaml
languages: ["en", "de", "fr"] # Supported languages
default_lang: "en" # Fallback language
exclude_from_localization: [...] # Paths to exclude
parallel_localization: true # Enable parallel processing
url: https://example.com # Site URL (required for URL relativization)
lang_from_path: true # (Optional) Extract lang from file path
permalink_lang: { page_id: "..." } # (v1.8.0+) Permalink info for languages
```

## Key Design Decisions

1. **Minimal coupling**: The plugin extends Jekyll rather than replacing its core behavior
2. **Parallel-friendly**: Document coordination works in both serial and parallel modes
3. **Fallback support**: Missing content in a language falls back to the default language
4. **URL consistency**: Permalinks must be identical across language variants (unless using `page_id`)
