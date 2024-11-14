<script setup lang="ts">
import { computed, ref } from 'vue';

const open = ref(false);
const userMessages = ref<{[date: number]: string}>({});
const llmMessages = ref<{[date: number]: string}>({0: "# Lorem Ipsum is \n\n\nsimply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum. It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum is that it has a more-or-less normal distribution of letters, as opposed to using 'Content here, content here', making it look like readable English. Many desktop publishing packages and web page editors now use Lorem Ipsum as their default model text, and a search for 'lorem ipsum' will uncover many web sites still in their infancy. Various versions have evolved over the years, sometimes by accident, sometimes on purpose (injected humour and the like).",
  1: "*test*"
});
const messages = computed(() => {
  const combinedMessages = {...userMessages.value, ...llmMessages.value};
  return Object.keys(combinedMessages)
    .sort((a, b) => Number(a) - Number(b))
    .reduce((acc: any, key: any) => {
      acc[key] = combinedMessages[key];
      return acc;
    }, {});
});
const newMessage = ref('');

const responseLoading = ref(false);

const currentTime = computed(() => Date.now());

const scrollChatBox = (timeout: number = 100) => {
  setTimeout(() => {
      const messageContainer = document.querySelector('.messages');
      if (messageContainer) {
        messageContainer.scrollTop = messageContainer.scrollHeight;
      }
    }, timeout);
}

async function sendMessageToLLM(message: string) {
  // send message to LLM
  // api call here (should be async)
  // simulate response (TODO: actual response)
  await new Promise((resolve, reject) => {
    // TODO: simulated error
    if (message === 'error') {
      reject('Error message');
    }
    setTimeout(() => {
      llmMessages.value[currentTime.value] = "I'm a bot, you said: " + message;
      resolve(true);
    }, 2000);
  });
}

// TODO: implement API call to LLM
async function sendMessage() {
  if (newMessage.value.trim() !== '') {
    // Create a new message object in order to clear the chatbox (looks better when sending)
    const m = newMessage.value;
    newMessage.value = '';
    userMessages.value[currentTime.value] = (m);
    // Scroll to the bottom of the messages
    scrollChatBox();

    // send message to LLM
    // api call here (should be async)
    responseLoading.value = true;

    sendMessageToLLM(m).then(() => {
      console.log('Message sent to LLM');
      responseLoading.value = false;
      scrollChatBox();
    }).catch((error) => {
      console.error('Failed to send message to LLM:', error);
      llmMessages.value[currentTime.value] = "There was an error loading a response...";
      responseLoading.value = false;
    });
  }
};
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