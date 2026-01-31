---
applyTo: "lib/jekyll/polyglot/hooks.rb,lib/jekyll/polyglot/hooks/**/*.rb"
---

# Hooks and Hook Implementation Instructions

## Overview

The `hooks.rb` and `hooks/` directory contain Jekyll hook integrations that intercept the Jekyll build process to add i18n capabilities.

## Hook Execution Model

- The `post_init` hook runs in `lib/jekyll/polyglot/hooks.rb` and sets up configuration after Jekyll initializes
- Individual hooks in `hooks/` directory are called during the build process
- Hooks run **serially by default** but can run in parallel based on `parallel_localization` config
- Always test with both serial and parallel execution enabled

## When Adding/Modifying Hooks

1. **Understand Jekyll's hook lifecycle**: Hooks intercept at specific points (post_init, post_write, etc.)
2. **Test with sample sites**: Use `spec/fixture/` sites with various language configurations
3. **Document the hook purpose**: Add comments explaining when/why the hook runs
4. **Test parallel behavior**: If modifying process flow, verify behavior with `parallel_localization: true` and `false`
5. **Run full test suite**: `COVERAGE=true bundle exec rspec spec/jekyll/polyglot/hooks/`

## Common Hook Tasks

- **Document coordination**: Grouping documents by language happens in `hooks/coordinate.rb`
- **Asset filtering**: Per-language asset processing in `hooks/assets-toggle.rb`
- **Build orchestration**: Main hook logic in `hooks/process.rb`

## Testing Hooks

Hooks are tested in `spec/jekyll/polyglot/hooks/` with integration tests against fixture Jekyll sites. When modifying a hook:

1. Add/update tests in the corresponding spec file
2. Run the specific hook tests: `bundle exec rspec spec/jekyll/polyglot/hooks/coordinate_spec.rb`
3. Run all hook tests: `bundle exec rspec spec/jekyll/polyglot/hooks/`
4. Verify RuboCop compliance: `bundle exec rubocop lib/jekyll/polyglot/hooks.rb`
