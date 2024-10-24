<script setup lang="ts">
import LineChart from './visualizations/LineChart.vue';
</script>

<template>
  <div class="vis-container">
    <v-container fluid class="fill-height">
      <v-row class="fill-height">
        <v-col class="fill-height">
          <LineChart />
        </v-col>
      </v-row>
    </v-container>
  </div>
</template>

<style scoped>
.vis-container {
  display: flex;
  flex-direction: column;
  height: 100vh; /* Full viewport height */
  padding: 0;
  margin: 0;
}

.fill-height {
  height: 100%;
}
</style>