---
applyTo: "lib/jekyll/polyglot/patches.rb,lib/jekyll/polyglot/patches/**/*.rb"
---

# Patches and Core Class Extensions Instructions

## Overview

The `patches.rb` and `patches/` directory extend Jekyll core classes with i18n capabilities without modifying Jekyll's source.

## Design Principles for Patches

- **Only add methods**: Never override or replace existing Jekyll methods
- **Minimize changes**: Patches should be the smallest possible extension to achieve i18n
- **Test thoroughly**: Patches modify core Jekyll classes; test against multiple Jekyll versions
- **Document side effects**: Clearly note if patches change Jekyll's behavior in any way

## Patch Locations

- `lib/jekyll/polyglot/patches.rb` — Main patch file; requires and applies all patches
- `lib/jekyll/polyglot/patches/jekyll/site.rb` — Extensions to Jekyll::Site class
- Other `patches/jekyll/` files — Extensions to other Jekyll core classes

## When Modifying Patches

1. **Understand the patched class**: Read Jekyll documentation for the class you're modifying
2. **Add the method, don't override**: Methods should extend functionality, not replace it
3. **Test with sample Jekyll sites**: Use `spec/fixture/` to test against realistic Jekyll configurations
4. **Document the new method**: Add comments explaining what the method does and why it's needed
5. **Write comprehensive tests**: Patches affect core behavior; test extensively

## Testing Patches

Patches are tested in `spec/jekyll/polyglot/` with integration tests against fixture Jekyll sites. When modifying a patch:

1. Add/update tests in `spec/jekyll/polyglot/patches/` with clear names like `spec/jekyll/polyglot/patches/jekyll/site_spec.rb`
2. Run patch tests: `bundle exec rspec spec/jekyll/polyglot/`
3. Verify RuboCop compliance: `bundle exec rubocop lib/jekyll/polyglot/patches.rb`
4. Test with `bash make.sh` to ensure the example site still builds correctly

## Common Pitfalls

- **Don't override existing methods**: This breaks Jekyll's expected behavior
- **Don't assume Jekyll's internal structure**: Jekyll may change internals; test against different Jekyll versions
- **Don't add heavy dependencies**: Patches should be lightweight extensions
