<script setup lang="ts">
import { ref } from 'vue';
import { useTheme } from 'vuetify';
import { currentView, currentTheme } from './state'; // Import the global ref

const open = ref(false);
const theme = useTheme();

const toggleTheme = async () => {
  theme.global.name.value = theme.global.name.value === 'light' ? 'dark' : 'light';
};

const switchToLineChart = () => {
  currentView.value = 'lineChart';
};

const switchToMap = () => {
  currentView.value = 'map';
};

</script>

<template>
  <v-navigation-drawer v-model="open" app>
    <v-switch
      @change="toggleTheme"
      class="theme-toggle-switch d-flex justify-center"
      label="Toggle theme"
    >
      <template v-slot:label>
        <v-icon right>mdi-weather-night</v-icon>
      </template>
    </v-switch>
    <div class="button-container">
      <v-btn class="custom-btn line-chart-btn" @click="switchToLineChart">Line Chart</v-btn>
      <v-btn class="custom-btn map-btn" @click="switchToMap">Map</v-btn>
    </div>
  </v-navigation-drawer>
  <v-btn
    :class="[ 'toggle-btn', open ? 'open' : '' ]"
    @click="open = !open"
    icon
  >
    <v-icon
      :icon="open ? 'mdi-chevron-left' : 'mdi-chevron-right'"
      size="large"
    ></v-icon>
  </v-btn>

</template>

<style scoped>
  .toggle-btn {
    position: absolute;
    top: 50%;
    transform: translateY(-50%);
    left: -5px; /* Change from right to left */
    max-width: 32px;
    min-height: 64px;
    background-color: --var(--v-theme-background);
    border: 1px solid #ccc;
    border-radius: 4px;
    z-index: 1;
    transition: all 0.2s;
  }
  .toggle-btn.open {
    left: 250px; 
  }
  .button-container {
    display: flex;
    flex-direction: column; /* Arrange buttons vertically */
    align-items: center;
    justify-content: center;
    gap: 10px; /* Add space between buttons */
    margin-top: 20px; /* Add some margin at the top */
  }
  .custom-btn {
    width: 90%; /* Ensure buttons take full width */
  }
  .line-chart-btn {
    background-color: #4caf50; /* Green background for Line Chart button */
    color: white; /* White text color */
  }
  .map-btn {
    background-color: #2196f3; /* Blue background for Map button */
    color: white; /* White text color */
  }
</style>