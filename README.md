# Abdisa Tsegaye — Portfolio

A developer portfolio that opens on real content, with a full browser-based
operating system one click away.

**Live:** https://abdisaongithub.github.io/

## Structure

The landing page is the default surface — hero, live GitHub stats, real
projects, skills and contact. Entering an OS shell is an explicit choice, and
the BIOS animation plays as the transition into it rather than as a gate in
front of the site.

## Curating content

| What | Where |
|------|-------|
| **Projects** | `lib/features/projects/project.dart` — `kProjects`. Single source for the landing grid, the Projects app and the command palette. |
| **Skills** | Same file — `kSkills`. |
| **Experience** | `lib/features/apps/widgets/experience_app.dart` — `kExperience`. Currently placeholder. |
| **Contact details** | `lib/core/profile.dart`. |
| **Demo videos** | Set `videoId` on a project (a YouTube id) and a player appears on its detail view. |

## What it does

The site detects your platform, so "Enter the OS" boots the shell you actually
run — a Windows visitor gets Windows, an iPhone gets iOS. The switcher marks
that shell **YOURS** and can always take you back to it.

Five shells, switchable at any time:

| Mode | What you get |
|------|--------------|
| **Windows 11** | Desktop icons, Mica taskbar with running-window buttons, Fluent-style title bars |
| **macOS** | Menu bar with a live clock, magnified dock, traffic-light window controls |
| **Ubuntu** | GNOME top bar, side dock, Yaru-orange window chrome |
| **Android** | App grid launcher with status and navigation bars |
| **iOS** | Home screen with a frosted dock |

On a desktop browser the two mobile modes render inside a simulated phone
frame; on an actual phone they render full-bleed, in any orientation.

### Apps

- **Terminal** — `ls`, `cd`, `pwd`, `cat`, `mkdir`, `touch`, `open`, `exit`, plus
  command history on the arrow keys. Backed by a real in-memory filesystem.
- **Projects** — the real work, with links to source and published packages.
- **Files** — virtual filesystem browser; double-click to open files in the right app.
- **Markdown viewer**, **Gallery**, **Settings** (wallpaper, theme, OS), **CV**.
- **GitHub status** — live repo and follower counts, clickable, in every shell.
- **Now playing** — adapts to the host chrome: a full card in the Windows
  taskbar, a single line in the macOS/GNOME menu bars, a glyph in phone status
  bars.

### Window manager

Windows can be dragged, resized from the bottom-right grip, maximized (button or
double-click the title bar), minimized to the taskbar, and focused by z-order.
Dragging is clamped so a window can never be lost off-screen.

## Getting started

```bash
flutter pub get
flutter run -d chrome
```

Requires Flutter 3.41+ (Dart 3.11+). Targets web only — `package:web` is used
directly for the fullscreen toggle.

## Development

```bash
flutter analyze          # must be clean
flutter test             # 93 tests
flutter build web --release --base-href /
```

Code generation, after touching anything annotated with `@freezed`:

```bash
dart run build_runner build --delete-conflicting-outputs
```

## Media embeds

Spotify and YouTube playback go through each provider's official embed iframe,
composited as a Flutter platform view (`lib/core/embed/`). We do not rehost the
media — the provider serves and licenses it. Logged-out Spotify visitors get
the 30-second preview; Premium subscribers who are signed in get the full
track. That split is Spotify's rule.

`dart:ui_web` and `package:web` do not exist on the Dart VM, so the embed
helpers sit behind a conditional import. Importing them directly makes any
dependent widget untestable.

## Architecture

State lives in four cubits, all provided at the root in `lib/main.dart`:

| Cubit | Responsibility |
|-------|----------------|
| `OSModeCubit` | Which OS is active, and whether the phone frame is forced |
| `WindowManagerCubit` | Window list, z-order, geometry, minimize/maximize |
| `ThemeCubit` | Wallpaper and dark mode, persisted via `SharedPreferences` |
| `FileSystemCubit` | Immutable `FileNode` tree — `cd`, `ls`, `mkdir`, `touch` |
| `NowPlayingCubit` | Shared mock playback state for the OS chrome |
| `GithubCubit` | Live profile and repo data from the GitHub API |

Two indirections keep the OS shells decoupled from the apps they host:

- `AppLauncherService` maps an `AppType` to either a window or an external URL.
- `WindowContentBuilder` maps a `WindowContentType` to the widget that renders it.

Each desktop supplies only its own chrome and reserved insets, then delegates to
the shared `WindowLayer`:

```dart
const WindowLayer(
  style: WindowButtonStyle.windows,
  insets: EdgeInsets.only(bottom: 48), // taskbar
)
```

### Adding a project

Projects are data, not code. Create `assets/projects/<id>/manifest.json`:

```json
{
  "id": "my-project",
  "title": "My Project",
  "description": "What it does.",
  "version": "1.0.0",
  "techStack": ["Flutter", "Dart"],
  "tags": ["Mobile"],
  "repoUrl": "https://github.com/...",
  "gallery": []
}
```

Then declare the folder in `pubspec.yaml`:

```yaml
assets:
  - assets/projects/my-project/
```

> Flutter's asset globbing is **not** recursive. A folder that isn't listed
> explicitly is silently never bundled — `ProjectLoaderService`'s test guards
> against exactly that regression.

The manifest is mounted into the virtual filesystem at
`/home/abdisa/projects/<id>/`, alongside a `README.md` generated from its
description, and becomes visible in the terminal, Explorer and editor.

## Deployment

`.github/workflows/deploy.yml` runs `analyze` and `test` on every push and PR to
`main`, and builds and deploys to GitHub Pages on push to `production`.

```bash
git checkout production && git merge main && git push
```

## Project layout

```
lib/
├── core/design/               Design tokens + shared UI primitives
├── core/embed/                Provider iframes as platform views
├── core/profile.dart          Contact details, single source of truth
├── core/platform_detector.dart  Which shell a visitor lands on
├── core/live_clock.dart       Shared clock for every status bar
├── main.dart                  Root providers → BootScreen
├── main_orchestrator.dart     OSMode → desktop, phone frame, fullscreen
└── features/
    ├── landing/               The default portfolio surface
    ├── projects/              Curated project data
    ├── command/               Ctrl-K command palette
    ├── boot/                  BIOS transition into a shell
    ├── desktop/               windows/ mac/ linux/ + shared wallpaper
    ├── mobile/                android/ ios/ launchers
    ├── web/                   Glassmorphic landing page
    ├── virtual_window/        Window manager, frames, task strip
    ├── apps/                  Terminal, editor, explorer, settings, now playing
    ├── file_system/           FileNode tree, manifests, loader
    ├── switcher/              Floating OS picker
    └── theme/                 Wallpaper + dark mode
```
