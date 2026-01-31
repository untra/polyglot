# AGENTS.md: Guidelines for Contributing to jekyll-polyglot

**jekyll-polyglot** is a fast, open-source internationalization (i18n) plugin for Jekyll blogs.

---

## Quick Start

1. **Install dependencies**: `bundle install`
2. **Run tests**: `bash test.sh` (runs RuboCop linting + RSpec tests with coverage)
3. **Create a feature branch**: `git checkout -b feature/my-feature`
4. **Make changes** to `lib/jekyll/polyglot/` with accompanying tests in `spec/`
5. **Commit** with conventional commit messages (see below)
6. **Push** and open a Pull Request

---

## Commit Message Format

Follow **conventional commit** style:

```
type(scope): brief description

Longer explanation if needed.

Closes #issue_number
```

**Types**: `feat`, `fix`, `docs`, `style`, `refactor`, `test`, `chore`

---

## Documentation by Topic

### For Writing Code

- [ARCHITECTURE.md](ai_docs/ARCHITECTURE.md) — Plugin architecture and how components interact
- [SECURITY.md](ai_docs/SECURITY.md) — Security best practices, input validation, and performance

### For Testing

- [TESTING.md](ai_docs/TESTING.md) — Test organization, writing tests, and coverage requirements

---

## Project Structure

| Directory                        | Purpose                                        |
| -------------------------------- | ---------------------------------------------- |
| `lib/`                           | Core plugin code                               |
| `lib/jekyll/polyglot/hooks.rb`   | Jekyll hook integration                        |
| `lib/jekyll/polyglot/patches.rb` | Jekyll core class extensions                   |
| `lib/jekyll/polyglot/liquid.rb`  | Custom Liquid filters and tags                 |
| `spec/`                          | RSpec test suite (mirrors `lib/` structure)    |
| `spec/fixture/`                  | Sample Jekyll sites for integration testing    |
| `site/`                          | Example polyglot blog demonstrating the plugin |

---

## Build and Test Commands

```bash
# Install dependencies
bundle install

# Run all tests and linting
bash test.sh

# Run only tests (skip linting)
COVERAGE=true bundle exec rspec

# Run a specific test file
bundle exec rspec spec/jekyll/polyglot/hooks/coordinate_spec.rb

# Build the gem and example site
bash make.sh

# Run the example site locally
cd site
jekyll serve
# Visit http://localhost:4000
```

---

## Key Requirements

- **Ruby 3.1.0 or higher**
- **Bundler** for dependency management
- All code must pass **RuboCop** linting
- New features must include tests (aim for >90% coverage)
- Follow **conventional commit** message style

---

## Important Files

| File                                               | Purpose                                    |
| -------------------------------------------------- | ------------------------------------------ |
| [README.md](README.md)                             | Usage examples and configuration reference |
| [CONTRIBUTING.md](CONTRIBUTING.md)                 | Contribution guidelines                    |
| [jekyll-polyglot.gemspec](jekyll-polyglot.gemspec) | Gem specification and dependencies         |
| [Gemfile](Gemfile)                                 | Development dependencies                   |
| [test.sh](test.sh)                                 | Main test script (runs RuboCop + RSpec)    |
| [make.sh](make.sh)                                 | Builds the gem and example site            |
