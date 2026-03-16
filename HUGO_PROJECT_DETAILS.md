# Hugo Project Details

## Site Overview

**The Amazing API** is a static website built with Hugo that showcases an API documentation site. The site includes:

- **Home Page**: Welcome page with navigation cards to main sections
- **Our Tech Story**: Background and technical information about the API
- **Using the API**: Comprehensive API documentation with code examples
- **Our Customers**: Information about customers using the API
- **Meet the Team**: Team member profiles with individual bio pages
  - Alice Lee - Product Manager
  - Bob Johnson - Data Scientist & UI/UX Designer
  - Jane Smith - Data Scientist & Frontend Developer
  - John Doe - Software Engineer

The site uses a modern, responsive design with a clean UI featuring gradient accents and card-based layouts. It's configured for GitHub Pages deployment with canonical URLs and lowercase file naming conventions.

## Project Structure

Hugo follows a convention-based directory structure that organizes content, templates, and static assets. The core directories include:

| Directory/File | Description |
| -------------- | ----------- |
| `config.toml` | The main configuration file that defines site settings, theme configuration, and build parameters |
| `content/` | Contains all markdown content files organized in a hierarchical structure that mirrors the site's URL structure |
| `layouts/` | Houses HTML templates that define how content is rendered, with `_default/` containing base templates |
| `static/` | Stores static assets like CSS, JavaScript, images, and other files that are copied directly to the output |
| `public/` | The generated static site output directory (created during build, typically excluded from version control) |

The following directory tree shows the structure of this Hugo project:

```bash
HUGO/
├── config.toml          # Hugo configuration
├── content/             # Markdown content files
│   ├── _index.md        # Homepage content
│   ├── our_tech_story.md
│   ├── using_the_api.md
│   ├── our_customers.md
│   ├── meet_the_team.md
│   └── team_member.md   # Individual team member pages
├── layouts/             # HTML templates
│   ├── _default/
│   │   ├── baseof.html  # Base template with header/footer
│   │   ├── single.html  # Single page template
│   │   ├── taxonomy.html
│   │   └── term.html
│   ├── index.html       # Homepage template
│   └── shortcodes/
│       └── pageref.html # Page reference shortcode
├── static/              # Static assets (CSS, JS, images)
│   └── assets/
│       ├── css/
│       │   └── style.css
│       └── js/
│           └── main.js
├── public/              # Generated static site (created by build)
├── scripts/
│   └── test_site.sh     # Test suite script
└── Makefile             # Build automation
```

## Makefile Commands

The project includes a Makefile for common development tasks. Run `make` or `make help` to see all available commands.

### `make help`

Display available Makefile targets and their descriptions.

```bash
make help
```

### `make build`

Build the static site by running Hugo. This generates all HTML files in the `public/` directory.

```bash
make build
```

**What it does:**

- Processes all markdown files in `content/`
- Applies templates from `layouts/`
- Copies static assets from `static/`
- Generates the complete static site in `public/`

### `make serve`

Start the Hugo development server. The server runs on `http://localhost:1313` by default and automatically reloads when files change.

```bash
make serve
```

**What it does:**

- Live reload on file changes
- Accessible at `http://localhost:1313`
- Press `Ctrl+C` to stop the server

### `make test`

Run the automated test suite that validates all site links and assets.

```bash
make test
```

**What it does:**

- Starts Hugo server in the background on port 13199
- Tests all page links (home, main pages, team member pages)
- Tests static assets (CSS and JavaScript files)
- Reports any broken links or missing files
- Automatically stops the server when done

The test script automatically detects the `baseURL` path from `config.toml` to handle GitHub Pages subdirectory configurations.

### `make clean`

Remove all generated files and build artifacts.

```bash
make clean
```

**What it does:**

- Removes `public/` directory (all generated HTML files)
- Removes `.hugo_build.lock` file (Hugo lock file)

Use this when you want a fresh build or before committing changes.

## Development Workflow

| Step | Command | Details |
|------|---------|---------|
| **Getting Started** | | |
| 1. Build the site | `make build` | Generates all HTML files in the `public/` directory |
| 2. Start development server | `make serve` | Server runs on `http://localhost:1313` with auto-reload |
| 3. View the site | — | Open `http://localhost:1313` in your browser |
| **Making Changes** | | |
| 1. Edit content | — | Modify markdown files in `content/` |
| 2. Edit templates | — | Modify HTML templates in `layouts/` |
| 3. Edit styles | — | Modify CSS in `static/assets/css/style.css` |
| 4. Preview changes | — | Development server auto-reloads on file changes |
| **Testing Changes** | | |
| Run test suite | `make test` | Validates all links and assets work correctly before committing or deploying |
| **Clean Build** | | |
| Fresh build | `make clean`<br>`make build` | Removes all generated files, then rebuilds from scratch |

## Configuration

### Base URL

The site is configured for GitHub Pages deployment with a subdirectory path. The `baseURL` in `config.toml` is set to:

```yaml
baseURL = "https://GITHUB_USER_NAME.github.io/GITHUB_USER_NAME-GITHUB_REPO_NAME/"
```

The test suite automatically detects and uses this path when testing links.

### Permalinks

Pages use the filename (slug) directly for URLs:

- `meet_the_team.md` → `/meet_the_team/`
- `alice_lee.md` → `/alice_lee/`

### Canonical URLs

`canonifyURLs = true` ensures all URLs are absolute, which is required for GitHub Pages subdirectory deployments.

## Features

- **Responsive Design**: Works on desktop, tablet, and mobile devices
- **Card-based Navigation**: Interactive cards on homepage with hover effects
- **Team Member Cards**: Clickable team member cards on the "Meet the Team" page
- **Modern UI**: Gradient accents, clean typography, and smooth transitions
- **Link Validation**: Automated testing ensures all links work correctly

## Troubleshooting

### Test Suite Fails

- Ensure Hugo is installed and accessible: `hugo version`
- Check that port 13199 is not in use
- Verify `config.toml` has a valid `baseURL` setting

### Links Don't Work

- Run `make test` to identify broken links
- Ensure all markdown files use lowercase filenames
- Check that `baseURL` path matches your deployment configuration

### Build Errors

- Run `make clean` to remove old build artifacts
- Check for syntax errors in markdown files
- Verify template syntax in `layouts/` files
