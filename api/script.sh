#!/bin/bash


# # For a clean install
# if brew services list | grep -q ollama; then
#   echo "Stopping existing Ollama service..."
#   brew services stop ollama
# fi

# if [ -d "$APP_DIR/homebrew" ]; then    
#   echo "Removing existing Homebrew installation..."
#   rm -rf "$APP_DIR/homebrew"
# fi

# if [ -f "$BREW_BIN/ollama" ]; then    
#   echo "Removing existing Ollama binary..."        
#   rm -f "$BREW_BIN/ollama"  
# fi

# brew uninstall ollama


USER_HOME="$HOME"
APP_DIR="$USER_HOME/Applications"
BREW_BIN="$USER_HOME/Applications/homebrew/bin"
OLLAMA_HOST="127.0.0.1:11434"
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
OLLAMA_HOST=$OLLAMA_HOST nohup ollama serve &
ollama run $OLLAMA_MODEL <<< "/bye"

# Sample Response
curl -X POST http://0.0.0.0:11434/api/generate -d "{\"model\":\"$OLLAMA_MODEL\", \"prompt\":\"$PROMPT\"}"
