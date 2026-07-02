import { StrictMode } from 'react'
import { createRoot } from 'react-dom/client'
import './index.css' // global styles (fonts, colors, dark mode) shared by the whole app
import App from './App.tsx'

// find the empty <div id="root"> from index.html, and draw <App /> inside it —
// this is the one line that actually puts React's output on the page
createRoot(document.getElementById('root')!).render(
  <StrictMode>
    {/* StrictMode: dev-only helper that highlights common bugs (e.g. impure
        code) by intentionally double-running some code; removed in the
        production build, has zero effect on the final site */}
    <App />
  </StrictMode>,
)
