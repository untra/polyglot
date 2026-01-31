# AGENTS.md: Guidelines for Contributing to jekyll-polyglot

This document provides guidance for AI agents and developers working with the jekyll-polyglot project. It outlines the project structure, build and test procedures, coding conventions, architecture, and security considerations.

---

## Project Overview and Structure

**jekyll-polyglot** is a fast, open-source internationalization (i18n) plugin for Jekyll blogs. It enables multi-language Jekyll sites with fallback support, automatic URL relativization, and powerful SEO tools.

### Directory Structure

- **`lib/`** – Core Ruby library code for the jekyll-polyglot plugin
  - `lib/jekyll-polyglot.rb` – Main entry point that requires the plugin
  - `lib/jekyll/polyglot.rb` – Core plugin loader that requires submodules
  - `lib/jekyll/polyglot/liquid.rb` – Custom Liquid filters and tags for i18n
  - `lib/jekyll/polyglot/hooks.rb` – Jekyll hooks that integrate the plugin with Jekyll's build process
  - `lib/jekyll/polyglot/patches.rb` – Patches to Jekyll core classes for i18n support
  - `lib/jekyll/polyglot/version.rb` – Version definition
  - `lib/jekyll/polyglot/hooks/` – Individual hook implementations (e.g., coordinate, subprocess)

- **`spec/`** – RSpec test suite
  - `spec/jekyll/polyglot/` – Tests for individual plugin components
  - `spec/fixture/` – Test fixtures and sample Jekyll sites
  - `spec/support/` – Test helper utilities

- **`site/`** – Example Jekyll blog demonstrating polyglot functionality
  - Multilingual content in various language codes (e.g., `en`, `de`, `fr`, `ar`, `ja`, `ko`, etc.)
  - Uses the plugin to build a polyglot documentation site

- **Build and Configuration Files**
  - `Gemfile` – Ruby dependencies (testing frameworks, linters, Jekyll plugins)
  - `jekyll-polyglot.gemspec` – Gem specification and metadata
  - `Rakefile` – Rake tasks for testing
  - `test.sh` – Main test script (runs RuboCop and RSpec with coverage)
  - `make.sh` – Builds the gem and example site
  - `CONTRIBUTING.md` – Contribution guidelines

---

## Build and Test Instructions

### Prerequisites

- **Ruby 3.1.0 or higher** (as specified in gemspec)
- **Bundler** for managing dependencies

### Setup

```bash
# Install dependencies
bundle install

# Navigate to the site directory to test the example site
cd site
```

### Running Tests

All tests are run via the `test.sh` script, which performs linting and unit testing:

```bash
# Run all tests, linting, and coverage
bash test.sh
```

This command:

1. Runs **RuboCop** for style linting
2. Runs **RSpec** tests with coverage reporting
3. Uploads coverage results to Codecov (if in CI with token)
4. Returns exit code 0 on success, 1 on failure

To run only RSpec tests without linting:

```bash
COVERAGE=true bundle exec rspec
```

To run a specific test file:

```bash
bundle exec rspec spec/jekyll/polyglot/hooks/coordinate_spec.rb
```

### Building the Gem and Example Site

```bash
# Build the gem and rebuild the example site
bash make.sh
```

### Running the Example Site Locally

```bash
cd site
jekyll serve
# Navigate to http://localhost:4000
```

---

## Coding Conventions and Style Guidelines

### Ruby Style and Standards

- **Ruby Version**: Code must support **Ruby 3.1.0 or higher**
- **Style Guide**: Follow **PEP-like conventions** (similar to Python's style); use **RuboCop** for enforcement
  - Indentation: Use **2 spaces** (standard Ruby convention)
  - Line length: Aim for < 120 characters
  - Naming: Use `snake_case` for methods and variables; `CamelCase` for classes and constants; `UPPER_SNAKE_CASE` for constants
  - Use double quotes for strings (unless interpolation is heavy, then single quotes)

### Code Quality

- All code is checked with **RuboCop** (including performance and RSpec plugins)
- Ensure no linting errors before submitting code: `bundle exec rubocop`
- Write clear, self-documenting code with descriptive variable and method names
- Add comments for complex logic, especially in hooks and patches

### Gem Metadata and Versioning

- Semantic versioning is used (MAJOR.MINOR.PATCH)
- Version is defined in `lib/jekyll/polyglot/version.rb`
- Gem requires **MFA (Multi-Factor Authentication)** for publishing (see gemspec)

### Jekyll Integration

- The plugin hooks into Jekyll's build process through `Jekyll::Hooks`
- Plugins must be compatible with **Jekyll >= 4.0**
- Use Jekyll's standard configuration system via `_config.yml`
- Follow Jekyll naming conventions for plugins, tags, and filters

---

## Architecture and Design Patterns

### Plugin Architecture

jekyll-polyglot integrates with Jekyll through several key mechanisms:

1. **Hooks** (`lib/jekyll/polyglot/hooks.rb` and `hooks/` directory)
   - `post_init` hook: Sets up configuration and language mappings after Jekyll initializes
   - Other hooks: Handle document coordinate setup, output relocation, and build orchestration
   - Hooks run serially or in parallel based on the `parallel_localization` config setting

2. **Patches** (`lib/jekyll/polyglot/patches.rb`)
   - Extends Jekyll core classes (e.g., `Jekyll::Document`, `Jekyll::Site`) with i18n capabilities
   - Adds methods for language detection, document grouping, and URL relativization
   - Patches are applied at require time

3. **Liquid Filters and Tags** (`lib/jekyll/polyglot/liquid.rb`)
   - Custom Liquid filters for rendering language-aware content in templates
   - `static_href` filter: Relativizes URLs for multi-language sites
   - `t` filter: Translates strings in Liquid templates

### Data Model: Document Coordination

- Documents are grouped by their permalink (or `page_id` in v1.7.0+)
- Each document has a `lang` frontmatter property indicating its language
- The plugin "coordinates" documents with the same permalink across languages
- Parallel localization: By default, language processing happens in parallel (configurable)

### Key Configuration Properties

Users configure polyglot in `_config.yml`:

```yaml
languages: ["en", "de", "fr"] # Supported languages
default_lang: "en" # Fallback language
exclude_from_localization: [...] # Paths to exclude
parallel_localization: true # Enable parallel processing
url: https://example.com # Site URL (required for URL relativization)
lang_from_path: true # (Optional) Extract lang from file path
```

---

## Testing Guidelines

### Testing Philosophy

- **Required**: All new features and bug fixes must include tests
- **Coverage Target**: Aim for > 90% code coverage on new modules
- **Framework**: Use **RSpec** for unit and integration tests
- Tests verify plugin hooks, patches, Liquid filters, and Jekyll integration

### Test Organization

```
spec/
  jekyll/
    polyglot/
      hooks/
        coordinate_spec.rb             # Tests for document coordination
        subprocess_spec.rb             # Tests for parallel processing
      [other feature specs]
  fixture/
    [sample Jekyll sites for integration testing]
  spec_helper.rb                       # RSpec configuration and setup
```

Tests mirror the source code structure under `lib/jekyll/polyglot/`.

### Writing Tests

1. **Unit Tests**: Test individual methods and filters
   - Example: `spec/jekyll/polyglot/hooks/coordinate_spec.rb`
   - Use RSpec's `describe`, `context`, and `it` blocks

2. **Integration Tests**: Test plugin interaction with Jekyll
   - Use fixture sites in `spec/fixture/` for full Jekyll builds
   - Verify output HTML structure and language routing

3. **Test Fixtures**: The `spec/fixture/` directory contains sample Jekyll sites
   - Use these to test against realistic site structures
   - Add new fixtures for edge cases (e.g., complex permalinks, different language combinations)

### Running Tests

```bash
# Full test suite with coverage
COVERAGE=true bundle exec rspec

# Run with verbose output
bundle exec rspec --format documentation

# Run a specific test file
bundle exec rspec spec/jekyll/polyglot/hooks/coordinate_spec.rb

# Run only tests matching a pattern
bundle exec rspec --pattern "*coordinate*"
```

### Code Coverage

- Coverage reports are generated in `coverage/` directory by SimpleCov
- Coverage results are uploaded to Codecov in CI environments
- The `test.sh` script handles coverage report generation and CI uploads

---

## Security and Best Practices

### Configuration and Secrets

- **Never hard-code secrets or API keys** in the plugin code
- Users configure the plugin exclusively via Jekyll's `_config.yml`
- Configuration values are passed through Jekyll's config system

### Input Validation and Safety

- **Document Language Codes**: Assume language codes come from user frontmatter; validate format follows [I18n language code conventions](https://developer.chrome.com/docs/extensions/reference/api/i18n#locales)
- **URL Relativization**: The plugin handles URL transformation; test with special characters and unicode in permalinks
- **Patch Safety**: Patches to Jekyll core classes should only add methods; avoid overriding existing behavior without thorough testing

### Compatibility and Maintenance

- **Jekyll Compatibility**: Keep compatibility with Jekyll >= 4.0; test against multiple Jekyll versions in CI if possible
- **Ruby Compatibility**: Support Ruby 3.1.0+; use syntax compatible with these versions
- **Dependency Management**: Keep dependencies minimal; prefer Jekyll's built-in functionality over external gems

### Performance Considerations

- **Parallel Localization**: The plugin can process languages in parallel (`parallel_localization: true`)
  - Use this for large sites; set to `false` for Windows hosts or if conflicts occur with other plugins
  - Tests in `subprocess_spec.rb` verify parallel behavior

- **N+1 Prevention**: When iterating over documents, group by language first to avoid redundant processing
- **Caching**: Leverage Jekyll's build cache where possible

### Error Handling

- Log errors through Jekyll's logger (`jekyll.logger`)
- Provide helpful error messages that guide users to fix their configuration or file structure
- Handle missing translations gracefully (fallback to default language)

### SEO and URLs

- Polyglot provides SEO tools via Liquid filters
- Ensure `hreflang` alternate links are correctly generated for all language variants
- URLs must be consistent across language versions for proper SEO

---

## Important Files for Contributors

Key files to review when contributing:

| File                                                             | Purpose                                                        |
| ---------------------------------------------------------------- | -------------------------------------------------------------- |
| [README.md](README.md)                                           | Main documentation; usage examples and configuration reference |
| [CONTRIBUTING.md](CONTRIBUTING.md)                               | Contribution guidelines and testing instructions               |
| [lib/jekyll/polyglot.rb](lib/jekyll/polyglot.rb)                 | Core plugin loader and submodule requires                      |
| [lib/jekyll/polyglot/hooks.rb](lib/jekyll/polyglot/hooks.rb)     | Main Jekyll hook integration                                   |
| [lib/jekyll/polyglot/patches.rb](lib/jekyll/polyglot/patches.rb) | Jekyll core class extensions                                   |
| [lib/jekyll/polyglot/liquid.rb](lib/jekyll/polyglot/liquid.rb)   | Custom Liquid filters and tags                                 |
| [jekyll-polyglot.gemspec](jekyll-polyglot.gemspec)               | Gem specification and dependencies                             |
| [Gemfile](Gemfile)                                               | Development dependencies (RSpec, RuboCop, etc.)                |
| [spec/jekyll/polyglot/](spec/jekyll/polyglot/)                   | Test suite (mirrors source structure)                          |

---

## Commit Message Guidelines

When creating commits, follow conventional commit style:

```
type(scope): brief description

Longer explanation if needed.

Closes #issue_number
```

**Types**: `feat`, `fix`, `docs`, `style`, `refactor`, `test`, `chore`

**Examples**:

- `feat(hooks): add language detection from file path`
- `fix(liquid): correct URL relativization for special characters`
- `docs: update README with new language support`
- `test(hooks): add tests for coordinate hook with custom permalinks`

---

## Deployment and Release Process

- **Version Bumping**: Update `lib/jekyll/polyglot/version.rb`
- **Gem Publishing**: Use `gem push` to publish to rubygems.org
- **MFA Requirement**: MFA is required for gem publishing (configured in gemspec)
- **CI/CD**: CircleCI runs tests and coverage checks on all PRs
- **Codecov**: Coverage reports are automatically uploaded for PR review

---

## Resources and References

- [Jekyll Documentation](https://jekyllrb.com/docs/)
- [I18n Language Codes](https://developer.chrome.com/docs/extensions/reference/api/i18n#locales)
- [RSpec Documentation](https://rspec.info/)
- [RuboCop Documentation](https://rubocop.org/)
- [Polyglot Live Demo](https://polyglot.untra.io/)
- [GitHub Repository](https://github.com/untra/polyglot)

---

## Quick Start for Contributors

1. **Fork and clone** the repository
2. **Install dependencies**: `bundle install`
3. **Create a feature branch**: `git checkout -b feature/my-feature`
4. **Make changes** to `lib/jekyll/polyglot/` with accompanying tests in `spec/`
5. **Run tests**: `bash test.sh` (linting + tests with coverage)
6. **Commit** with clear, conventional commit messages
7. **Push** to your fork and **open a Pull Request**

For more details, see [CONTRIBUTING.md](CONTRIBUTING.md).
