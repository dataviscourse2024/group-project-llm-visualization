<template>
  <div class="vis-container">
    <v-container class="fill-height">
      <v-col class="chart-container">
        <v-row class="fill-height">
          <component :is="currentViewComponent" :data="filteredChartData" />
        </v-row>
        <v-row v-if="currentView === 'lineChart'">
          <TimeSlider :data="chartData" @updateWindow="updateWindow" />
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
import Map from './visualizations/Map.vue';
import FetchButton from './FetchButton.vue';
import TimeSlider from './TimeSlider.vue';
import { ref, computed } from 'vue';
import { currentView } from './state'; // Import the global ref

const chartData = ref([]);
const filteredChartData = ref([]);

const currentViewComponent = computed(() => {
  return currentView.value === 'lineChart' ? LineChart : Map;
});

const updateChartData = (data) => {
  chartData.value = data;
  filteredChartData.value = data; // Initialize with full data
};

const updateWindow = ({ start, end }) => {
  filteredChartData.value = chartData.value.filter(d => new Date(d.time) >= start && new Date(d.time) <= end);
};
</script>