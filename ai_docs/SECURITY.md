# Security and Best Practices

## Configuration and Secrets

- **Never hard-code secrets or API keys** in the plugin code
- Users configure the plugin exclusively via Jekyll's `_config.yml`
- Configuration values are passed through Jekyll's standard config system
- Do not commit sensitive data (tokens, API keys) to the repository

## Input Validation and Safety

### Document Language Codes

- Language codes come from user frontmatter
- Validate format follows [I18n language code conventions](https://developer.chrome.com/docs/extensions/reference/api/i18n#locales)
- Reject or sanitize invalid language identifiers

### URL Relativization

- The plugin handles URL transformation for multi-language sites
- Test thoroughly with special characters and unicode in permalinks
- Ensure relative URLs work correctly across all language variants

### Patch Safety

- Patches to Jekyll core classes should **only add methods**
- Avoid overriding existing behavior without thorough testing
- Document any behavior changes that affect Jekyll's standard operations

## Compatibility and Maintenance

### Jekyll Compatibility

- Keep compatibility with **Jekyll >= 4.0**
- Test against multiple Jekyll versions in CI if possible
- Document any version-specific behavior or workarounds

### Ruby Compatibility

- Support **Ruby 3.1.0+**
- Use syntax compatible with this version range
- Test code on the minimum supported version before release

### Dependency Management

- Keep dependencies minimal
- Prefer Jekyll's built-in functionality over external gems
- Review and update dependencies regularly for security patches

## Performance Considerations

### Parallel Localization

- The plugin can process languages in parallel when `parallel_localization: true`
- Use parallel processing for large sites with many languages
- Set to `false` for:
  - Windows hosts (known compatibility issues)
  - Sites that conflict with other Jekyll plugins
  - Development environments where serial processing is easier to debug
- Tests in `subprocess_spec.rb` verify correct parallel behavior

### N+1 Prevention

- When iterating over documents, group by language first to avoid redundant processing
- Use efficient document lookups (avoid searching the entire site for each language variant)

### Caching

- Leverage Jekyll's build cache where possible
- Avoid recalculating document coordinates on unchanged content
- Cache language mappings and configuration lookups

## Error Handling

- Log errors through Jekyll's logger (`jekyll.logger`)
- Provide helpful, actionable error messages that guide users to fix their setup:
  - Include the problematic file or configuration value
  - Suggest solutions (e.g., "Missing `url` in `_config.yml`; URL relativization requires this")
- Handle missing translations gracefully by falling back to the default language
- Don't expose internal stack traces or implementation details to users

## SEO and URLs

- Polyglot provides SEO tools via Liquid filters
- Ensure `hreflang` alternate links are correctly generated for all language variants
- URLs must be **consistent and valid** across language versions for proper SEO
- Test URL generation with various permalink formats and language combinations
