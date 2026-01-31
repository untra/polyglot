# Copilot Coding Agent Instructions for jekyll-polyglot

## Repository Overview

**jekyll-polyglot** is a fast, open-source internationalization (i18n) plugin for Jekyll static site generator blogs. It enables multi-language Jekyll sites with fallback support, automatic URL relativization, and SEO tools.

- **Type**: Ruby gem / Jekyll plugin
- **Size**: ~516 lines of source code across 11 files
- **Primary Language**: Ruby 3.1.0+
- **Framework Dependencies**: Jekyll >= 4.0
- **Testing Framework**: RSpec with SimpleCov coverage
- **Linting**: RuboCop with performance and RSpec plugins
- **CI/CD**: CircleCI with Codecov for coverage tracking

## Essential Commands

Always run these commands in this order:

```bash
# 1. Install dependencies (REQUIRED - always run first)
bundle install

# 2. Run linting only (quick check, ~10 seconds)
bundle exec rubocop

# 3. Run tests with coverage (full validation, ~30 seconds)
COVERAGE=true bundle exec rspec

# 4. Build gem and test example site (optional, for integration testing)
bash make.sh
```

**Do not skip step 1.** Always run `bundle install` before running any other commands, even if you think dependencies are already installed.

## Build and Validation Checklist

Before opening a pull request, **always verify**:

- [ ] Run `bundle install` (dependencies)
- [ ] Run `bundle exec rubocop` (linting passes)
- [ ] Run `COVERAGE=true bundle exec rspec` (all tests pass)
- [ ] New code includes tests (aim for >90% coverage)
- [ ] No test files added/modified unless code changes require it
- [ ] Changes follow conventional commit format: `type(scope): description`

Failing any of these will cause the PR to be rejected by CircleCI.

## Project Structure

```
lib/
  jekyll-polyglot.rb              # Gem entry point
  jekyll/polyglot.rb              # Main plugin loader
  jekyll/polyglot/
    hooks.rb                      # Jekyll hook integration (post_init, etc.)
    patches.rb                    # Jekyll core class patches
    liquid.rb                     # Custom Liquid filters/tags
    version.rb                    # Version constant (update for releases)
    hooks/
      coordinate.rb               # Document grouping by language
      process.rb                  # Main hook orchestration
      assets-toggle.rb            # Asset filtering per language
    liquid/tags/
      i18n_headers.rb            # SEO hreflang generation
      static_href.rb             # URL relativization filter
    patches/jekyll/
      site.rb                    # Site class extensions
      [other patch files]

spec/
  jekyll/polyglot/               # RSpec test suite (mirrors lib/ structure)
  fixture/                       # Sample Jekyll sites for integration tests
  spec_helper.rb                 # RSpec configuration

site/                            # Example polyglot blog (multi-language demo)

Configuration & Build:
  .rubocop.yml                  # RuboCop linting rules (TargetRubyVersion: 3.1)
  .rspec                        # RSpec configuration (outputs rspec.xml, rspec.json)
  .circleci/config.yml          # CircleCI pipeline (Ruby 3.1 Docker image)
  codecov.yml                   # Codecov coverage threshold (80% target)
  jekyll-polyglot.gemspec       # Gem specification (version, dependencies, metadata)
  Gemfile                       # Development dependencies
```

## CI/CD Pipeline Validation

CircleCI automatically runs these steps on every PR:

1. **Build job**: Runs on Ruby 3.1 Docker image, installs dependencies via `ruby/install-deps` orb
2. **Test job**: Runs `./test.sh` which:
   - Executes `bundle exec rubocop` (linting)
   - Executes `COVERAGE=true bundle exec rspec` (tests + coverage)
   - Generates `rspec.xml` and `rspec.json` for test reporting
   - Uploads coverage to Codecov (requires `CODECOV_TOKEN` in CI environment)

**If tests fail locally, they will fail in CircleCI.** Always validate locally before pushing.

## Key Architecture Patterns

### Document Coordination

The plugin groups Jekyll documents by their permalink across languages:

- Documents declare language via `lang` frontmatter property
- Documents with identical permalinks are "coordinated" as translations
- Optional `page_id` frontmatter (v1.7.0+) allows different URLs per language

### Three Integration Points

1. **Hooks** (`hooks.rb`): Intercept Jekyll build process at key points
   - `post_init` hook: Sets up language mappings after Jekyll initializes
   - Runs serially or parallel based on `parallel_localization` config

2. **Patches** (`patches.rb`): Extend Jekyll core classes with i18n methods
   - Add language detection, document grouping, URL relativization
   - Only add methods; never override existing behavior

3. **Liquid Filters** (`liquid.rb`): Template-level internationalization
   - `static_href` filter: Relativizes URLs for multi-language sites
   - `t` filter: Translates strings in templates

## Coding Standards

**RuboCop enforces all style rules.** Configuration in `.rubocop.yml` requires:

- Ruby 3.1+ syntax
- 2-space indentation
- No line length limit (disabled in config)
- Specific method indentation rules (see config file)

Run `bundle exec rubocop` to check. The CI pipeline will fail if RuboCop finds issues.

## Testing Requirements

**All code changes must include tests.** Test structure mirrors `lib/`:

- New code in `lib/jekyll/polyglot/hooks.rb` → add tests to `spec/jekyll/polyglot/hooks_spec.rb`
- Tests use RSpec `describe`, `context`, and `it` blocks
- Use fixture sites in `spec/fixture/` for integration testing against real Jekyll builds

Coverage is tracked by Codecov. Target >90% for new code.

## Common Pitfalls

- **Don't skip `bundle install`**: Even if you think dependencies are installed, run it. Bundler manages the exact versions.
- **Don't modify version.rb casually**: Only update `lib/jekyll/polyglot/version.rb` during releases.
- **Don't patch Jekyll classes without testing**: Changes to `patches.rb` must be thoroughly tested across Jekyll versions.
- **Don't hard-code secrets**: All configuration comes from `_config.yml`; never embed API keys.
- **Don't assume RuboCop won't complain**: Run locally before committing; CircleCI will reject non-compliant code.

## Debugging Tips

- **If tests fail**: Check that you ran `bundle install` first. Then run `COVERAGE=true bundle exec rspec` with verbose output: `bundle exec rspec --format documentation`
- **If RuboCop complains**: Run `bundle exec rubocop -A` to auto-fix fixable issues (but review changes)
- **If build.sh fails**: Navigate to `site/` and run `jekyll build` directly to see detailed Jekyll output
- **For integration testing**: The `spec/fixture/` directory contains sample Jekyll sites; run tests against these to catch real-world issues

## Additional Resources

Refer to [AGENTS.md](../AGENTS.md) for contributor guidelines and detailed documentation:

- [ARCHITECTURE.md](../ai_docs/ARCHITECTURE.md) — In-depth plugin design and data model
- [TESTING.md](../ai_docs/TESTING.md) — Detailed test writing patterns
- [SECURITY.md](../ai_docs/SECURITY.md) — Security constraints and best practices
