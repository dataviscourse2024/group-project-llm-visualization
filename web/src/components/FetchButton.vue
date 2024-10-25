<template>
  <v-row justify="center" class="mt-4">
    <v-col cols="auto">
      <v-btn class="btn-large" color="primary" @click="sendPostRequest">Fetch Earthquake Data</v-btn>
    </v-col>
    
    <!-- Display the response -->
    <v-col v-if="response" class="mt-2">
      <h3>Response:</h3>
      <pre>{{ response }}</pre>
    </v-col>

    <!-- Display any errors -->
    <v-col v-if="error" class="mt-2">
      <h3>Errors:</h3>
      <pre>{{ error }}</pre>
    </v-col>
  </v-row>
</template>

<script setup lang="ts">
import { ref } from 'vue';
import axios from 'axios';

const response = ref(null);
const error = ref(null);

const sendPostRequest = async () => {
  try {
    const data = {
      start_time: "2024-05-23T00:00:00",
      end_time: "2024-09-23T00:00:00"
    };

    const result = await axios.post('http://127.0.0.1:8000/get_data', data);
    response.value = result.data;
    error.value = null;
  } catch (err) {
    error.value = err.response ? err.response.data : err.message;
  }
};
</script>

<style scoped>
.btn-large {
  font-size: 1.25rem;
  padding: 12px 24px; 
}
</style>
