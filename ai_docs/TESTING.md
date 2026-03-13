# Testing Guidelines

## Testing Philosophy

- **Mandatory**: All new features and bug fixes must include tests
- **Coverage target**: Aim for > 90% code coverage on new modules
- **Framework**: Use **RSpec** for unit and integration tests
- **Scope**: Tests should verify plugin hooks, patches, Liquid filters, and Jekyll integration

## Test Organization

Test structure mirrors the source code structure under `lib/jekyll/polyglot/`:

```
spec/
  jekyll/
    polyglot/
      hooks/
        coordinate_spec.rb        # Document coordination tests
        subprocess_spec.rb        # Parallel processing tests
      [other feature specs]
  fixture/
    [sample Jekyll sites for integration testing]
  spec_helper.rb                  # RSpec configuration and setup
```

## Writing Tests

### Unit Tests

Test individual methods and filters in isolation:

- **Location**: Mirror the source file structure (e.g., tests for `lib/jekyll/polyglot/hooks.rb` go in `spec/jekyll/polyglot/hooks_spec.rb`)
- **Structure**: Use RSpec's `describe`, `context`, and `it` blocks
- **Example**: `spec/jekyll/polyglot/hooks/coordinate_spec.rb`

### Integration Tests

Test plugin interaction with Jekyll as a whole:

- **Setup**: Use fixture sites in `spec/fixture/` for full Jekyll builds
- **Verification**: Check output HTML structure, language routing, and URL generation
- **Edge cases**: Add new fixtures for complex scenarios (e.g., custom permalinks, different language combinations)

## Running Tests

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

## Code Coverage

- Coverage reports are generated in the `coverage/` directory by **SimpleCov**
- Coverage results are uploaded to **Codecov** in CI environments
- The `test.sh` script handles coverage report generation and automated CI uploads
- Check coverage reports before committing to ensure no regression

## Testing Parallel Localization

The `subprocess_spec.rb` tests verify parallel behavior. When testing parallel processing:

- Ensure the `parallel_localization: true` config is set
- Test on non-Windows systems (parallel mode has known issues on Windows)
- Verify that language variants process independently without race conditions
