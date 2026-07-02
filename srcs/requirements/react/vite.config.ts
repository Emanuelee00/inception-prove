import { defineConfig } from 'vite'
import react from '@vitejs/plugin-react'

// https://vite.dev/config/
export default defineConfig({
  plugins: [react()],
  // served under /app/ (not domain root) so the mandatory WordPress site
  // stays reachable at "/" — this makes built asset URLs start with
  // /app/assets/... instead of /assets/...
  base: '/app/',
})
