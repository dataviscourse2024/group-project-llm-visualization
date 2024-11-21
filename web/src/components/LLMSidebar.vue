<script setup lang="ts">
import { ref, computed } from 'vue';
import { currentSelection } from '../store';

const open = ref(false);
const userMessages = ref<{ [date: number]: string }>({});
const llmMessages = ref<{ [date: number]: string }>({});
const newMessage = ref('');
const responseLoading = ref(false);

const messages = computed(() => {
  const combinedMessages = { ...userMessages.value, ...llmMessages.value };
  return Object.keys(combinedMessages)
    .sort((a, b) => Number(a) - Number(b))
    .reduce((acc, key) => {
      acc[key] = combinedMessages[key];
      return acc;
    }, {} as { [date: number]: string });
});

const scrollChatBox = (timeout: number = 100) => {
  setTimeout(() => {
    const messageContainer = document.querySelector('.messages');
    if (messageContainer) {
      messageContainer.scrollTop = messageContainer.scrollHeight;
    }
  }, timeout);
};

let websocket: WebSocket | null = null;

async function initializeWebSocket() {
  websocket = new WebSocket('ws://localhost:80/generate');

  websocket.onopen = () => {
    console.log('WebSocket connection established');
  };

  websocket.onmessage = (event) => {
    const time = Date.now();
    console.log('Received message:', event.data);
    const msg = event.data.split("\n")
    .filter(line => line.trim()) 
    .map(line => JSON.parse(line).response)
    .join("");
    
    llmMessages.value[time] = msg;

    responseLoading.value = false;

    scrollChatBox();
  };

  websocket.onerror = (error) => {
    console.error('WebSocket error:', error);
    llmMessages.value[Date.now()] = 'WebSocket encountered an error.';
  };

  websocket.onclose = () => {
    console.log('WebSocket connection closed');
    llmMessages.value[Date.now()] = 'Connection closed.';
  };
}

async function sendMessage() {
  if (newMessage.value.trim() !== '') {
    const m = newMessage.value;

    newMessage.value = '';
    userMessages.value[Date.now()] = m;
    scrollChatBox();

    responseLoading.value = true;

    try {
      if (websocket && websocket.readyState === WebSocket.OPEN) {
      console.log(currentSelection.value);
      const dataToSend = m + "\n" + "SELECTION:" + JSON.stringify(currentSelection.value);

      websocket.send(dataToSend);
      } else {
        throw new Error('WebSocket is not connected');
      }
    } catch (error) {
      console.error('Failed to send message:', error);
      llmMessages.value[Date.now()] = 'Failed to send message to server.';
    }
  }
}

initializeWebSocket();
</script>


<template>
  <v-navigation-drawer
    v-model="open"
    app
    location="right"
    width="400"
  >
    <div class="chat-container">
      <h2 class="sidebar-title">LLM Chat</h2>
      <div class="messages">
        <div v-if="responseLoading" class="overlay">
          <v-progress-circular indeterminate color="primary"></v-progress-circular>
        </div>
        <div 
          v-for="([time, message], index) in Object.entries(messages)" 
          :key="index" 
          :class="['message', Object.keys(userMessages).includes(time) ? 'user-message' : '']"
        >
            {{ message }}
        </div>
      </div>
      <div class="input-area">
        <v-text-field
          v-model="newMessage"
          @keyup.enter="sendMessage"
          placeholder="Type a message"
          dense
          outlined
          class="message-input"
        ></v-text-field>
        <v-btn @click="sendMessage" icon>
          <v-icon>mdi-send</v-icon>
        </v-btn>
      </div>
    </div>
  </v-navigation-drawer>
  <v-btn
    :class="[ 'toggle-btn', open ? 'open' : '' ]"
    @click="open = !open"
    icon
  >
    <v-icon>{{ open ? 'mdi-chevron-right' : 'mdi-chevron-left' }}</v-icon>
  </v-btn>
</template>

<style scoped>
.toggle-btn {
  position: absolute;
  top: 50%;
  transform: translateY(-50%);
  right: -5px;
  z-index: 0;
  max-width: 32px;
  min-height: 64px;
  background-color: var(--v-theme-background);
  border: 1px solid #ccc;
  border-radius: 4px;
}
.toggle-btn.open {
    right: 395px; 
}

.overlay {
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background-color: rgba(255, 255, 255, 0.5);
  display: flex;
  justify-content: center;
  align-items: center;
}

.chat-container {
  display: flex;
  flex-direction: column;
  height: 100%;
}

.sidebar-title {
  padding: 5px;
  background-color: var(--v-theme-surface);
  color: var(--v-theme-on-surface);
  margin: 0;
}

.messages {
  flex: 1;
  align-content: end;
  overflow-y: auto;
  padding: 10px;
  background-color: var(--v-theme-surface);
}

.message {
  margin-bottom: 10px;
  padding: 10px;
  background-color: rgba(149, 230, 199, 0.5);
  border-radius: 4px;
}

.user-message {
  align-self: flex-end;
  background-color: rgba(149, 194, 230, 0.5);
  color: var(--v-theme-on-primary);
}

.input-area {
  display: flex;
  padding: 10px;
  background-color: var(--v-theme-surface);
}

.message-input {
  flex: 1;
  margin-right: 10px;
}
</style>