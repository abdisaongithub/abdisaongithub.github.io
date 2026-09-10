# Abdisa Portfolio OS — Project References

## Overview
Flutter **web** portfolio. The **landing page is the entry point**; five OS
shells (Windows 11, macOS, Ubuntu, Android, iOS) sit behind an explicit action.

`OSMode.web` no longer exists. Being on the landing page is
`OSModeState.isInOS == false`.

`setMode` replays the boot transition **only while inside the OS**.

### Payload budget — read before adding anything heavy

Flutter web ships its own renderer, so there is a hard floor of roughly
**2.4 MB gzipped** on first paint. Measured:

| Path | First paint (gzip) |
|------|--------------------|
| dart2js + CanvasKit | 2.83 MB |
| dart2wasm + skwasm (`--wasm`) | **2.43 MB** |

CI builds with `--wasm`; browsers without WasmGC fall back to the JS path
automatically. Rules that keep this from regressing:

1. **The OS surface is deferred.** `lib/features/os/os_surface.dart` is
   imported `deferred as` from `main_orchestrator.dart`, and pulls the five
   shells, the window-manager UI and every windowed app with it (~0.14 MB
   gzipped). **Anything OS-only must be reachable only through that library**,
   or it lands back in the initial bundle. The boot animation covers the
   download — `_BootGate` waits for both.
2. **Assets are lazy but not free.** Wallpapers are capped at 1920px (1080px
   for phone wallpapers) and stored as JPEG. `assets/` is 715 KB total; it was
   3.1 MB. Do not commit a PNG wallpaper.
3. **`web/index.html` paints the hero in plain HTML/CSS** before Flutter loads,
   so the first seconds show the name and role rather than a blank screen. If
   you change the hero copy, change it in both places.

### Speedrun

`SpeedrunCubit` performs a scripted tour: opens windows, drags and resizes one,
pushes a command into the terminal, switches OS, focuses the portfolio. It
drives the real cubits, so it is a genuine demo rather than a video.

- Delays are injectable (`delay:`), so the whole ~30s script runs instantly in
  tests.
- `takeOver()` cancels between awaits and leaves state untouched.
- The terminal consumes `state.typedCommand` via a `BlocListener` and types it
  out character by character, then calls `commandConsumed()`.
- **Any widget that mounts `TerminalApp` needs a `SpeedrunCubit` provider.**

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

### Design System

**Never hardcode a colour, radius, spacing value or duration.** Everything comes
from `lib/core/design/tokens.dart` (`AppColors`, `AppSpacing`, `AppRadius`,
`AppMotion`, `AppText`, `AppDecoration`), and shared widgets live in
`lib/core/design/ui.dart` (`AppButton`, `AppChip`, `SectionHeading`,
`ContentShell`, `Hoverable`, `FadeInUp`, `MeshBackdrop`).

`Hoverable` replaces the hand-rolled `_hovering` StatefulWidget that used to be
copy-pasted into every interactive surface.

### Content You Will Be Asked To Edit

| What | Where |
|------|-------|
| Projects | `lib/features/projects/project.dart` → `kProjects` |
| Skills | same file → `kSkills` |
| Experience | `lib/features/apps/widgets/experience_app.dart` → `kExperience` (placeholder) |
| Contact | `lib/core/profile.dart` |
| Demo video | set `videoId` on a `Project` |

`kProjects` feeds the landing grid, the Projects app **and** the command
palette. Add once, appears everywhere.

### Media Embeds

Spotify and YouTube run through the providers' official embed iframes, mounted
as platform views via `lib/core/embed/`. We never rehost media — that would be
infringement. Logged-out Spotify visitors get the 30s preview.

`dart:ui_web` / `package:web` do not compile on the Dart VM, so these sit behind
a conditional import (`web_embed_stub.dart` / `web_embed_web.dart`). The same
rule applies as for `platform_detector.dart`: **import the façade, never the
web file directly**, or the dependent widget becomes untestable.

### Feature Modules (all under `lib/features/`)
| Feature | Description |
|---------|-------------|
| `os/` | `OSSurface` — the deferred entry point for everything OS-only |
| `landing/` | Entry surface: nav, hero, projects, skills, OS teaser, contact |
| `landing/sections/` | Portfolio sections. **Must size from `LayoutBuilder`, not `MediaQuery`** — they render inside an OS window, not full-page |
| `speedrun/` | Scripted auto-playing tour + HUD |
| `command/` | Ctrl/Cmd-K command palette |
| `projects/` | Curated project data |
| `boot/` | `BootScreen` — short BIOS transition into a shell (no login screen) |
| `desktop/` | `WindowsDesktop`, `MacDesktop`, `LinuxDesktop`, plus shared `DesktopWallpaper` |
| `mobile/` | `AndroidLauncher` & `IosLauncher` — app grid with status/nav bars |
| `virtual_window/` | `WindowLayer`, `VirtualWindow`, `BaseWindowFrame`, `WindowTaskStrip`, `WindowContentBuilder`, `WindowContent` |
| `apps/` | Widgets: `TerminalApp`, `ProjectsApp`, `ProjectExplorer` (Files), `SettingsApp`, `ExperienceApp`, `GalleryApp`, `MarkdownViewerApp`, `GithubStatusWidget`, `NowPlayingWidget`, `SpotifyPlayer`, `VideoEmbed` |
| `apps/` | Services: `AppLauncherService` (routes taps to windows/external URLs), `GithubService` (reads the deploy-time GitHub snapshot) |
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

- `isInOS` / `isBooting` — landing vs shell. `enterOS(mode)` → boot →
  `bootComplete()`; `exitToLanding()` goes back. `bootComplete()` fires only
  once the deferred bundle has loaded *and* the animation has played.
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
`flutter_bloc`, `equatable`, `url_launcher`, `web`, `flutter_markdown_plus`, `flutter_highlight`, `cached_network_image`, `shared_preferences`, `uuid`, `freezed` + `json_serializable`.

### GitHub data — never call api.github.com from the browser

Unauthenticated GitHub API calls are capped at **60/hour per IP**, and visitors
behind carrier-grade NAT share one IP, so browser-side calls ran out for
everyone at once and returned 403.

- `tool/fetch_github_snapshot.dart` fetches profile + repos **at deploy time**
  (CI step "Refresh GitHub snapshot", using `GITHUB_TOKEN`) and writes
  `assets/data/github_snapshot.json`. If GitHub is unreachable it keeps the
  committed snapshot, so it never blocks a deploy.
- `GithubService` only reads that bundled asset. Refresh locally with
  `GITHUB_TOKEN=$(gh auth token) dart run tool/fetch_github_snapshot.dart`.
- Stats therefore update on each deploy, not live. Dio was removed with this
  change; do not re-add a runtime GitHub client.

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
- `flutter test` — 107 tests: filesystem, window manager, OS routing, now-playing sizing, project-data integrity (every link must be absolute https), terminal `exit`, asset bundling, and per-shell layout at three viewport widths

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
- Apps must accept `windowId` if they can act on their own frame (terminal `exit`)
- `launchUrl` on web: use `webOnlyWindowName: '_blank'`, **never**
  `LaunchMode.externalApplication` — it gets popup-blocked
