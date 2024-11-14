<template>
  <div class="vis-container">
    <v-container class="fill-height">
      <v-col class="chart-container">
        <v-row class="fill-height">
          <LineChart :data="chartData" />
        </v-row>
        <v-row>
          <FetchButton @data-fetched="updateChartData" /> <!-- Listen for data-fetched -->
        </v-row>
      </v-col>
    </v-container>
  </div>
</template>

<style scoped>
  .vis-container {
    height: 100%;
  }
</style>

<script setup lang="ts">
import LineChart from './visualizations/LineChart.vue';
import FetchButton from './FetchButton.vue';
import { ref } from 'vue';

const chartData = ref([]);

const updateChartData = (data) => {
  chartData.value = data;
};
</script>
