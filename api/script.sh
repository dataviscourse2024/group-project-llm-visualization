#!/bin/bash

USER_HOME="$HOME"
APP_DIR="$USER_HOME/Applications"
BREW_BIN="$USER_HOME/Applications/homebrew/bin"
OLLAMA_HOST="127.0.0.1:8888"
OLLAMA_MODEL="llama3.2:1b-instruct-q4_0"
PROMPT="Hi, tell me about yourself."

# Ollama
brew install ollama

# Update PATH in ~/.bash_profile
if ! grep -q "export PATH=$APP_DIR:" ~/.bash_profile; then
  echo "export PATH=$APP_DIR:\$PATH" >> ~/.bash_profile
fi

if ! grep -q "export PATH=$BREW_BIN:" ~/.bash_profile; then
  echo "export PATH=$BREW_BIN:\$PATH" >> ~/.bash_profile
fi

# Update
source ~/.bash_profile

# Start Ollama service
brew services start ollama

# Run Ollama server and model
OLLAMA_HOST=$OLLAMA_HOST ./ollama serve
ollama run $OLLAMA_MODEL

# Sample Response
curl -X POST http://localhost:11434/api/generate -d "{
  \"model\": \"$OLLAMA_MODEL\",
  \"prompt\": \"$PROMPT\"
}"

