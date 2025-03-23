#!/bin/bash

# Exit on error
set -e

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${GREEN}Running RuboCop...${NC}"
bundle exec rubocop

echo -e "${GREEN}Running RSpec tests with coverage...${NC}"
COVERAGE=true bundle exec rspec --format RspecJunitFormatter --out rspec.xml --format json --out rspec.json

# Check if tests passed
if [ $? -eq 0 ]; then
    echo -e "${GREEN}Tests passed!${NC}"
    
    # Upload coverage to Codecov if we're in CI
    if [ "$CI" = "true" ]; then
        echo -e "${GREEN}Uploading coverage to Codecov...${NC}"
        bash <(curl -s https://codecov.io/bash) -f "coverage/.last_run.json"
    fi
else
    echo -e "${RED}Tests failed!${NC}"
    exit 1
fi 