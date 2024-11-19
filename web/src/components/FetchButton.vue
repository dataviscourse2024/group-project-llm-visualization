<template>
  <div class="inputs-container">
    <label for="start-time">Start Time:</label>
    <input type="datetime-local" id="start-time" v-model="startTime" />

    <label for="end-time">End Time:</label>
    <input type="datetime-local" id="end-time" v-model="endTime" />

    <v-btn class="btn-large" color="primary" @click="fetchData">Fetch Earthquake Data</v-btn>
  </div>
</template>

<script setup lang="ts">
import { ref, defineEmits, onMounted } from 'vue';
import axios from 'axios';

const emit = defineEmits(['dataFetched']);
const startTime = ref('');
const endTime = ref('');

const fetchData = async () => {
  try {
    if (!startTime.value || !endTime.value) {
      alert('Please provide both start and end times');
      return;
    }

    const data = {
      start_time: startTime.value,
      end_time: endTime.value
    };

    const result = await axios.post('http://localhost:80/get_data', data);
    emit('dataFetched', result.data.features);
  } catch (error) {
    console.error("Failed to fetch data:", error);
  }
};

onMounted(() => {
  const start = new Date('2020-01-01T00:00:00');
  const end = new Date('2024-01-01T00:00:00');
  startTime.value = start.toISOString().slice(0, 16);
  endTime.value = end.toISOString().slice(0, 16);

  fetchData();
});
</script>

<style scoped>
.inputs-container {
  display: flex;
  align-items: center;
  gap: 10px;
  margin-bottom: 16px;
}

.btn-large {
  font-size: 1.25rem;
  padding: 6px 24px;
}
</style>
