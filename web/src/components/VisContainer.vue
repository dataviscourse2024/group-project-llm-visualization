<template>
  <div class="vis-container">
    <v-container fluid class="fill-height">
      <v-row class="fill-height">
        <v-col class="chart-container">
          <LineChart :data="chartData" /> <!-- Pass data as a prop -->
        </v-col>
      </v-row>
      <FetchButton @data-fetched="updateChartData" /> <!-- Listen for data-fetched -->
    </v-container>
  </div>
</template>

<script setup lang="ts">
import LineChart from './visualizations/LineChart.vue';
import FetchButton from './FetchButton.vue';
import { ref } from 'vue';

const chartData = ref([]);

const updateChartData = (data) => {
  chartData.value = data;
};
</script>
