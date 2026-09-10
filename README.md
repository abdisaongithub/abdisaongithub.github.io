# Abdisa Portfolio OS

An interactive portfolio built as a web-based operating system. Boot it, sign in,
and explore the work through a desktop you can actually use — drag windows around,
open a terminal, browse a virtual filesystem, read code in an editor.

**Live:** https://abdisaongithub.github.io/

## What it does

Six environments, switchable at any time from the floating switcher:

| Mode | What you get |
|------|--------------|
| **Windows 11** | Desktop icons, Mica taskbar with running-window buttons, Fluent-style title bars |
| **macOS** | Menu bar with a live clock, magnified dock, traffic-light window controls |
| **Ubuntu** | GNOME top bar, side dock, Yaru-orange window chrome |
| **Android** | App grid launcher with status and navigation bars |
| **iOS** | Home screen with a frosted dock |
| **Web** | A conventional glassmorphic landing page, for anyone who'd rather just scroll |

On a desktop browser, the two mobile modes render inside a phone frame.

### Apps

- **Terminal** — `ls`, `cd`, `pwd`, `cat`, `mkdir`, `touch`, `open`, plus command
  history on the arrow keys. Backed by a real in-memory filesystem.
- **VS Code** — syntax-highlighted viewer over the same virtual filesystem.
- **Explorer** — icon grid; double-click to open files in the right app.
- **Markdown viewer**, **Gallery**, **Settings** (wallpaper, theme, OS), **CV**.
- **GitHub status** and a **Spotify** widget in the system chrome.

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
flutter test             # 36 tests
flutter build web --release --base-href /
```

Code generation, after touching anything annotated with `@freezed`:

```bash
dart run build_runner build --delete-conflicting-outputs
```

## Architecture

State lives in four cubits, all provided at the root in `lib/main.dart`:

| Cubit | Responsibility |
|-------|----------------|
| `OSModeCubit` | Which OS is active, and whether the phone frame is forced |
| `WindowManagerCubit` | Window list, z-order, geometry, minimize/maximize |
| `ThemeCubit` | Wallpaper and dark mode, persisted via `SharedPreferences` |
| `FileSystemCubit` | Immutable `FileNode` tree — `cd`, `ls`, `mkdir`, `touch` |

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
├── core/profile.dart          Contact details, single source of truth
├── main.dart                  Root providers → BootScreen
├── main_orchestrator.dart     OSMode → desktop, phone frame, fullscreen
└── features/
    ├── boot/                  BIOS animation → login
    ├── desktop/               windows/ mac/ linux/ + shared wallpaper
    ├── mobile/                android/ ios/ launchers
    ├── web/                   Glassmorphic landing page
    ├── virtual_window/        Window manager, frames, task strip
    ├── apps/                  Terminal, editor, explorer, settings, widgets
    ├── file_system/           FileNode tree, manifests, loader
    ├── switcher/              Floating OS picker
    └── theme/                 Wallpaper + dark mode
```
