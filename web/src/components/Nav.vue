<script setup lang="ts">
import { ref } from 'vue';

const open = ref(true);

const items = [
  "Test", "Test 2", "Test 3"
]
</script>

<template>
  <v-navigation-drawer
    v-model="open"
  >
    <v-list
      :items="items"
  ></v-list>
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
    left: 0; /* Change from right to left */
    max-width: 32px;
    min-height: 64px;
    background-color: white;
    border: 1px solid #ccc;
    border-radius: 4px;
    z-index: 1; /* Ensure it appears above the drawer */
  }
  .toggle-btn.open {
    left: 250px; /* Adjust this value based on the width of your navigation drawer */
  }
</style>