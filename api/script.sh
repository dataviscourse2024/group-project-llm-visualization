#!/bin/bash

# Set variables for paths (modify these according to your setup)
USER_HOME="$HOME"
APP_DIR="$USER_HOME/Applications"
BREW_BIN="$USER_HOME/Applications/homebrew/bin"
OLLAMA_HOST="127.0.0.1:8888"
OLLAMA_MODEL="llama3.2:1b-instruct-q4_0"
PROMPT="Hi, tell me about yourself."

# Install Ollama using Homebrew
brew install ollama

# Update PATH in ~/.bash_profile (ensure no duplicates)
if ! grep -q "export PATH=$APP_DIR:" ~/.bash_profile; then
  echo "export PATH=$APP_DIR:\$PATH" >> ~/.bash_profile
fi

if ! grep -q "export PATH=$BREW_BIN:" ~/.bash_profile; then
  echo "export PATH=$BREW_BIN:\$PATH" >> ~/.bash_profile
fi

# Source updated profile
source ~/.bash_profile

# Start Ollama service
brew services start ollama

# Run Ollama server
OLLAMA_HOST=$OLLAMA_HOST ./ollama serve

# Use the specified model
ollama run $OLLAMA_MODEL

# Generate a response using curl
curl -X POST http://localhost:11434/api/generate -d "{
  \"model\": \"$OLLAMA_MODEL\",
  \"prompt\": \"$PROMPT\"
}"

