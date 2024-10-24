<script setup lang="ts">
import { ref } from 'vue';

const open = ref(false);
</script>

<template>
  <v-navigation-drawer
    v-model="open"
    app
    location="right"
  >
    WORK IN PROGRESS!!
  </v-navigation-drawer>
  <v-btn
    :class="[ 'toggle-btn', open ? 'open' : '' ]"
    @click="open = !open"
    icon
  >
    <v-icon
      :icon="open ? 'mdi-chevron-right' : 'mdi-chevron-left'"
      size="large"
    ></v-icon>
  </v-btn>
</template>

<style scoped>
  .toggle-btn {
    position: absolute;
    top: 50%;
    transform: translateY(-50%);
    right: 0;
    max-width: 32px;
    min-height: 64px;
    background-color: white;
    border: 1px solid #ccc;
    border-radius: 4px;
    z-index: 0;
  }
  .toggle-btn.open {
    right: 250px;
  }
</style>