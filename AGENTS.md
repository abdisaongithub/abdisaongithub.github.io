# Abdisa Portfolio OS — Project References

## Overview
Flutter **web** app that mimics multiple operating systems (Windows 11, macOS, Linux/Ubuntu, Android, iOS) as a portfolio showcase. Also features a "web mode" with a clean glassmorphic landing page. The app demonstrates both past projects and in-app capabilities (virtual file system, terminal, code editor, window manager).

Web is the only supported target. `main_orchestrator.dart` uses `package:web` directly.

## Architecture

### Entry Point
- `lib/main.dart` — `main()` runs `PortfolioApp` with `MultiBlocProvider` providing all 4 cubits
- `lib/main_orchestrator.dart` — `MainOrchestrator` routes to the correct OS desktop/launcher based on `OSModeCubit` state; also handles the mobile device simulation frame and the fullscreen toggle
- `lib/core/profile.dart` — **single source of truth** for name, email, phone, and social URLs. Never hardcode contact details anywhere else.
- `lib/core/platform_detector.dart` — decides the landing shell from the visitor's real platform. The browser probe lives behind a conditional import (`core/platform/platform_probe_{stub,web}.dart`) because `package:web` pulls in `dart:js_interop`, which does not compile on the Dart VM used by `flutter test`. **Anything importing `package:web` directly becomes untestable — go through the probe.**
- `lib/core/live_clock.dart` — shared clock; no shell should hardcode a time.

### State Management (flutter_bloc)
| Cubit | File | Purpose |
|-------|------|---------|
| `OSModeCubit` | `lib/features/os_mode/cubit/os_mode_cubit.dart` | Active shell, plus the `detected` platform and `isHandset` |
| `WindowManagerCubit` | `lib/features/virtual_window/cubit/window_manager_cubit.dart` | Opens/closes/focuses/minimizes/maximizes/moves/resizes virtual windows |
| `ThemeCubit` | `lib/features/theme/theme_cubit.dart` | Wallpaper selection + dark mode (persisted via SharedPreferences) |
| `FileSystemCubit` | `lib/features/file_system/cubit/file_system_cubit.dart` | Virtual filesystem: `cd`, `mkdir`, `touch`, tree traversal |

### Feature Modules (all under `lib/features/`)
| Feature | Description |
|---------|-------------|
| `boot/` | `BootScreen` (retro BIOS animation) → `LoginScreen` (GitHub avatar + sign in) |
| `desktop/` | `WindowsDesktop`, `MacDesktop`, `LinuxDesktop`, plus shared `DesktopWallpaper` |
| `mobile/` | `AndroidLauncher` & `IosLauncher` — app grid with status/nav bars |
| `web/` | `WebLauncher` — glassmorphic landing page with hero section + project grid |
| `virtual_window/` | `WindowLayer`, `VirtualWindow`, `BaseWindowFrame`, `WindowTaskStrip`, `WindowContentBuilder`, `WindowContent` |
| `apps/` | Widgets: `TerminalApp`, `CodeEditorApp`, `ProjectExplorer`, `SettingsApp`, `ExperienceApp`, `GalleryApp`, `MarkdownViewerApp`, `GithubStatusWidget`, `NowPlayingWidget` |
| `apps/` | Services: `AppLauncherService` (routes taps to windows/external URLs), `GithubService` (Dio-based GitHub API) |
| `file_system/` | Virtual FS: `FileNode`, `ProjectManifest` (freezed), `ProjectLoaderService` |
| `switcher/` | `OSSwitcherWidget` — floating bottom-right OS picker |
| `theme/` | `ThemeCubit` + `kOSWallpapers` — the canonical wallpaper map |

### Platform Detection & Routing

`OSModeCubit` seeds itself from `PlatformDetector.detect()`, so a Windows
visitor lands on Windows and an iPhone visitor on iOS. State carries three
things worth knowing:

| Field | Meaning |
|-------|---------|
| `mode` | The shell being rendered |
| `detected` | The visitor's real platform — never changes |
| `isHandset` | Real device is a phone-sized touch screen |

- `showsPhoneFrame` — **derived, not stored**: a mobile shell only gets wrapped
  in the simulated handset when `!isHandset`. It used to key off orientation,
  so rotating a real phone wrapped the launcher in a fake phone.
- `resetToDetected()` backs the switcher's "Back to <your OS>" row.
- Injecting `detect:` is how tests pin a device — see `test/support/test_harness.dart`.

### Chrome Insets

Each shell reserves screen edges, and two things must respect them:

| Shell | Chrome | Window insets | Switcher inset |
|-------|--------|---------------|----------------|
| Windows | 48px taskbar (bottom) | `bottom: 48` | 60 |
| macOS | 24px menu bar, 88px dock | `top: 24, bottom: 88` | 96 |
| Ubuntu | 28px top bar, 48px dock (left) | `top: 28, left: 48` | 24 |
| Android | 48px nav bar | — | 60 |
| iOS | 84px dock at offset 20 | — | 116 |
| Web | floating dock | — | 104 |

`_switcherInsetFor` in `main_orchestrator.dart` owns the right-hand column.
The switcher used to sit at a fixed 24px and covered every one of these.

### Now Playing

`NowPlayingWidget` has three variants because the host chrome heights differ by
2x. **Pick by available height, not by preference:**

| Variant | Fits | Used by |
|---------|------|---------|
| `full` | >= 44px | Windows taskbar |
| `compact` | <= 24px | macOS menu bar, GNOME top bar |
| `indicator` | <= 20px | Android + iOS status bars |

Dropping the `full` card into a 24px menu bar overflows by 17px on every frame.
`test/features/apps/now_playing_test.dart` pins each variant against the real
chrome heights, and `test/features/desktop/chrome_layout_test.dart` renders
every shell at desktop/laptop/phone widths and fails on any overflow.

### Virtual Window System
- `WindowContentType` enum: `profile`, `projectDetail`, `skills`, `experience`, `contact`, `webBrowser`, `terminal`, `code`, `settings`, `markdown`, `gallery`. Each has an `.icon` used by taskbars/docks.
- `AppLauncherService` maps `AppType` → a `WindowContent` or an external URL. **The switch is exhaustive — add a case when you add an `AppType`,** or the app silently does nothing.
- `WindowContentBuilder` maps `WindowContentType` → widget. Also exhaustive on purpose.
- **`WindowLayer` is shared.** Each desktop supplies only `style` (title bar look) and `insets` (chrome it reserves). Do not reintroduce per-OS window manager copies.
- **`WindowTaskStrip`** shows open windows in each taskbar/dock. Every desktop must include it — without it, minimizing a window makes it unreachable.
- Dragging is clamped against `bounds` so windows cannot be lost off-screen. Maximize preserves the original geometry rather than storing a separate "restore" rect.

### Project Data (Assets)
- `assets/projects/<id>/manifest.json` — loaded by `ProjectLoaderService` into the virtual filesystem
- Current projects: `portfolio`, `ecommerce-app`, `task-manager`
- Format: `ProjectManifest` (`id`, `title`, `description`, `version`, `techStack`, `tags`, `repoUrl`, `liveUrl`, `iconPath`, `gallery`)

> ⚠️ **Flutter asset declarations are not recursive.** Every new
> `assets/projects/<id>/` folder must get its own line under `flutter > assets`
> in `pubspec.yaml`. Listing only `assets/projects/` bundles nothing, and the
> failure is silent at runtime. `project_loader_service_test.dart` guards this.

### Key Dependencies (pubspec.yaml)
`flutter_bloc`, `equatable`, `dio`, `url_launcher`, `web`, `flutter_markdown_plus`, `flutter_highlight`, `cached_network_image`, `shared_preferences`, `uuid`, `freezed` + `json_serializable`.

`GithubService` is provided through `RepositoryProvider` at the root so widget
tests can substitute an offline stub; mounting the status widget without one
fires a live HTTP call and leaves a pending timer.

Keep this list tight — a batch of unused packages (`get_it`, `go_router`, `google_fonts`, `flutter_svg`, `image_picker`, `validators`, and others) was removed; don't add one back without a call site.

### CI/CD
- `.github/workflows/deploy.yml`
  - **verify** job — `dart format --set-exit-if-changed`, `flutter analyze --fatal-infos`, `flutter test`. Runs on every push to `main`/`production` and every PR to `main`.
  - **build + deploy** jobs — only on `production`, publishing to GitHub Pages.
- Promote a release with `git checkout production && git merge main && git push`.

### Lint / Analyze / Test
- `analysis_options.yaml` — `package:flutter_lints/flutter.yaml`
- `flutter analyze` must report **no issues** (CI uses `--fatal-infos`)
- `dart format lib test` before committing, or CI fails
- `flutter test` — 79 tests covering the filesystem, window manager, OS mode routing, now-playing sizing, asset bundling, and per-shell layout at three viewport widths

### Build & Run
- `flutter run -d chrome` — web dev
- `flutter build web --release --base-href /` — production build
- `dart run build_runner build --delete-conflicting-outputs` — after editing `@freezed` models

### Code Conventions
- `flutter_lints` lint set; no `print` (use `debugPrint`), no `withOpacity` (use `withValues(alpha:)`)
- State management: Bloc/Cubit pattern with `Equatable`
- File structure: feature-first under `lib/features/`
- Models: `freezed` for data classes with `fromJson`
- Never mutate widget state inside `build()` — hold an id and resolve it, as `CodeEditorApp` does
- Cubit methods that can fail should **return** an error string rather than logging it
- OS-specific UI: themed containers mimicking each platform's native look
