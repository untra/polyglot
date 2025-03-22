#!/bin/bash

# Exit on error
set -e

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${GREEN}Running RuboCop...${NC}"
bundle exec rubocop

echo -e "\n${GREEN}Running RSpec tests...${NC}"
bundle exec rspec --format RspecJunitFormatter --out rspec.xml

# Check if tests passed
if [ $? -eq 0 ]; then
  echo -e "\n${GREEN}All tests passed!${NC}"
else
  echo -e "\n${RED}Tests failed!${NC}"
  exit 1
fi 