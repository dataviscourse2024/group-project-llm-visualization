<script setup lang="ts">
import { ref } from 'vue';
import { useTheme } from 'vuetify'

const open = ref(false);
const theme = useTheme();

const toggleTheme = async () => {
  theme.global.name.value = theme.global.name.value === 'light' ? 'dark' : 'light';
};

</script>

<template>
  <v-navigation-drawer
    v-model="open"
    app
  >
    <v-switch
      @change="toggleTheme"
      class="theme-toggle-switch d-flex justify-center"
      label="Toggle theme"
    >
      <template v-slot:label>
        <v-icon right>mdi-weather-night</v-icon>
      </template>
    </v-switch>
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
  
</style>