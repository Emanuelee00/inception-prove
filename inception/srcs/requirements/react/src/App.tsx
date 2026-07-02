import './App.css'
// imports the stylesheet above — Vite bundles it into the page's <style>/CSS file at build time

// list of technologies shown as little badges in the "About" section
const STACK = [
  'Debian',
  'Docker Compose',
  'nginx',
  'WordPress',
  'php-fpm',
  'MariaDB',
  'React',
  'TypeScript',
  'Vite',
  'Python',
  'pygame',
]

function App() {
  // everything below "return (...)" is JSX: HTML-like syntax that becomes the page
  return (
    <div className="page">
      {/* className, not class: "class" is a reserved JS word, React renamed the prop */}

      <header className="hero">
        <h1>Inception</h1>
        <p className="tagline">
          A small self-hosted web infrastructure, built container by
          container from scratch with Docker.
        </p>
      </header>

      <section className="about">
        <h2>About this project</h2>
        <p>
          This is a 42 school system administration project: a WordPress
          site served over HTTPS through a custom nginx reverse proxy, with
          MariaDB as the database — each service built from its own
          Dockerfile (no pre-built application images), wired together with
          Docker Compose.
        </p>
        <p>
          This page and the game below are the bonus part: a React frontend
          replacing the static landing page, and a Pacman clone (Python /
          pygame) running in its own container and streamed live into the
          browser over VNC
        </p>

        {/* one <li> per entry in STACK, generated with .map() instead of
            writing 11 <li> tags by hand. "key" is required by React on
            list items so it can track which one is which when re-rendering */}
        <ul className="stack">
          {STACK.map((tech) => (
            <li key={tech}>{tech}</li>
          ))}
        </ul>
      </section>

      <section className="game">
        <h2>Play Pacman</h2>
        <p className="game-hint">Click inside the screen, then use the arrow keys.</p>
        <div className="game-frame">
          <iframe
            title="Pacman"
            // "path" tells noVNC's client where to open the WebSocket — by
            // default it connects to /websockify at the domain root, which
            // misses our /pacman/ nginx proxy entirely (it hits WordPress's
            // catch-all instead). This makes it connect to /pacman/websockify.
            src="/pacman/vnc_lite.html?autoconnect=true&resize=scale&reconnect=true&path=pacman/websockify"
            width="1200"
            height="900"
          />
        </div>
      </section>
    </div>
  )
}

export default App
// makes App importable from other files (main.tsx does: import App from './App.tsx')
