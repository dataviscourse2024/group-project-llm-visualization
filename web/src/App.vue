<script setup lang="ts">
import Nav from './components/Nav.vue';
import LLMSidebar from './components/LLMSidebar.vue';
import VisContainer from './components/VisContainer.vue';
import FetchButton from './components/FetchButton.vue';
</script>

<template>
  <v-app>
    <v-main>
      <Nav />
      <LLMSidebar />
      <VisContainer />
      <FetchButton />
    </v-main>
  </v-app>
</template>

<style scoped>
</style>