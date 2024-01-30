#!/bin/bash

# Function to create or update the GitHub Actions workflow file
create_github_workflow() {
    repo_owner=$1
    repo_name=$2
    github_token=$3

    # GitHub API endpoint for creating or updating workflows
    api_url="https://api.github.com/repos/$repo_owner/$repo_name/actions/workflows/main.yml"

    # Workflow YAML content
    workflow_content=$(cat <<EOL
name: Continuous Integration

on:
  push:
    branches:
      - main

jobs:
  build:
    runs-on: ubuntu-latest

    steps:
    - name: Checkout Repository
      uses: actions/checkout@v2

    - name: Set Up Python
      uses: actions/setup-python@v2
      with:
        python-version: 3.x

    - name: Install Dependencies
      run: |
        pip install -r requirements.txt

    - name: Run Tests
      run: |
        python -m unittest discover tests
EOL
)

    # JSON payload for creating or updating the workflow
    payload="{\"workflow\": {\"name\": \"Continuous Integration\", \"path\": \".github/workflows/main.yml\", \"content\": \"$(echo -n "$workflow_content" | base64)\"}}"

    # Send request to GitHub API
    response=$(curl -X PUT -H "Authorization: Bearer $github_token" -H "Accept: application/vnd.github.v3+json" -d "$payload" "$api_url")

    # Print the response
    echo "$response"
}

# Replace 'your_repo_owner', 'your_repo_name', and 'your_token' with actual values
repo_owner='your_repo_owner'
repo_name='your_repo_name'
github_token='your_token'

create_github_workflow "$repo_owner" "$repo_name" "$github_token"
