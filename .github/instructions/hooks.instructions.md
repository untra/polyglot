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

## Jekyll Hook Lifecycle

Polyglot uses hooks from Jekyll's hook system. Key hook points in the Jekyll build process:

- **`:site, :after_init`** — Just after the site initializes; good for modifying site configuration
- **`:documents, :post_init`** — Whenever any document is initialized
- **`:documents, :pre_render`** — Just before rendering a document (receives document + payload hash)
- **`:documents, :post_convert`** — After converting document content, before rendering layout
- **`:documents, :post_render`** — After rendering a document, before writing to disk
- **`:documents, :post_write`** — After writing a document to disk

Note: Individual collection hooks like `:posts` also work (documents in `_posts` collection).

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

## Hook Parameters

When registering hooks, understand the parameters passed to each hook:

- **`:post_init` hooks** receive the object being initialized (site, document, page, etc.)
- **`:pre_render` hooks** receive the object AND a `payload` hash containing Liquid template variables—modifying the payload controls what variables are available during rendering
- **`:post_convert` hooks** receive the object (available in Jekyll >= 4.2.0)
- **`:post_render` hooks** receive the object and rendered output
- **`:post_write` hooks** receive the object after writing to disk

For `:site, :post_render`, the payload contains final values after rendering the entire site (useful for sitemaps, feeds, etc.)

## Testing Hooks

Hooks are tested in `spec/jekyll/polyglot/hooks/` with integration tests against fixture Jekyll sites. When modifying a hook:

1. Add/update tests in the corresponding spec file
2. Run the specific hook tests: `bundle exec rspec spec/jekyll/polyglot/hooks/coordinate_spec.rb`
3. Run all hook tests: `bundle exec rspec spec/jekyll/polyglot/hooks/`
4. Verify RuboCop compliance: `bundle exec rubocop lib/jekyll/polyglot/hooks.rb`

## Best Practices for Hooks

- **Minimize hook scope**: Only register hooks for the specific owners/events you need
- **Avoid side effects in hooks**: Keep hooks pure; don't modify global state unless necessary
- **Log hook execution**: Use `Jekyll.logger.debug` to help with debugging hook behavior
- **Test with realistic content**: Use fixture sites with actual post/page/document structures
- **Consider performance**: Hooks run for every object; avoid expensive operations in frequently-triggered hooks like `:post_init`
- **Document hook dependencies**: If a hook depends on another hook running first, add comments explaining the execution order
