brew install ollama
echo "export PATH=/Users/jake/Applications/:$PATH" >> ~/.bash_profile && source ~/.bash_profile
echo "export PATH=/Users/jake/Applications/homebrew/bin:$PATH" >> ~/.bash_profile && source ~/.bash_profile
brew services start ollama

OLLAMA_HOST=127.0.0.1:8888 ollama serve
ollama run llama3.2:1b-instruct-q4_0

curl -X POST http://localhost:11434/api/generate -d '{
  "model": "llama3.2:1b-instruct-q4_0",
  "prompt":"Hi, tell me about yourself."
 }'