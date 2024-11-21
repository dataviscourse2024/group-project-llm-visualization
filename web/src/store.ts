import { ref } from 'vue'

export const currentSelection = ref<{} | null>(null)

export default {
  currentSelection,
}