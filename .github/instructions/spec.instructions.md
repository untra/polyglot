---
applyTo: "spec/**/*.rb"
---

# Test Suite Instructions

## Test Organization

The test suite is organized to mirror the source code structure:

```
spec/jekyll/polyglot/        # Tests mirror lib/jekyll/polyglot/ structure
  hooks/
    coordinate_spec.rb       # Tests for document coordination
    process_spec.rb          # Tests for hook orchestration
    assets-toggle_spec.rb    # Tests for asset filtering
  [other feature tests]

spec/fixture/                # Sample Jekyll sites for integration testing
  [fixture site directories]
```

## Running Tests

```bash
# Run all tests with coverage
COVERAGE=true bundle exec rspec

# Run tests with verbose output
bundle exec rspec --format documentation

# Run a specific test file
bundle exec rspec spec/jekyll/polyglot/hooks/coordinate_spec.rb

# Run tests matching a pattern
bundle exec rspec --pattern "*coordinate*"
```

## Writing Tests

When adding new features:

1. **Create a test file** in `spec/jekyll/polyglot/` mirroring the source structure
2. **Use RSpec conventions**: `describe`, `context`, and `it` blocks
3. **Test edge cases**: Special characters, unicode, missing translations, empty inputs
4. **Test integration**: Use fixture Jekyll sites to test against realistic builds
5. **Aim for >90% coverage**: New code should maintain high coverage

## Fixture Sites

The `spec/fixture/` directory contains sample Jekyll sites used for integration testing:

- Use fixtures to test document coordination with multiple languages
- Test URL relativization with different permalink formats
- Test fallback behavior when translations are missing
- When adding complex features, consider adding a new fixture

## Coverage Requirements

Coverage is tracked by Codecov with a target of 80% project coverage and 1% threshold tolerance:

- Run `COVERAGE=true bundle exec rspec` to generate coverage reports
- Reports are generated in `coverage/` directory
- Coverage must not decrease; CI will reject PRs with lower coverage
- Aim for >90% on new modules

## Common Assertions in Tests

- **Document grouping**: Verify documents with same permalink are grouped by language
- **URL generation**: Ensure URLs are correctly relativized for each language variant
- **Fallback behavior**: Verify missing content falls back to default language
- **Configuration parsing**: Test with various `_config.yml` configurations
