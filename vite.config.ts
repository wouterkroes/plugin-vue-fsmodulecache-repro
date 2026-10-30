import vue from '@vitejs/plugin-vue'
import { defineConfig } from 'vitest/config'

export default defineConfig({
  plugins: [vue()],
  test: {
    environment: 'happy-dom',
    // Experiment knobs (defaults = Vitest 5 defaults)
    fsModuleCache: process.env.FS_CACHE !== '0',
    css: process.env.CSS === '1',
  },
})
