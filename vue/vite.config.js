import { fileURLToPath, URL } from 'node:url'

import { defineConfig } from 'vite'
import vue from '@vitejs/plugin-vue'

// https://vite.dev/config/
export default defineConfig({
  plugins: [
    vue(),
  ],
  resolve: {
    alias: {
      '@': fileURLToPath(new URL('./src', import.meta.url)),
      '@config': fileURLToPath(new URL('./config', import.meta.url))
    },
  },
  server: {
    proxy: {
      // 开发环境同源代理，避免 localhost 与 127.0.0.1 跨域导致上传异常
      '/web': {
        target: 'http://127.0.0.1:9090',
        changeOrigin: true
      }
    }
  }
})

