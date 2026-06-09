# Abdisa Portfolio OS — Project References

## Overview
Flutter web app that mimics multiple operating systems (Windows 11, macOS, Linux/Ubuntu, Android, iOS) as a portfolio showcase. Also features a "web mode" with a clean glassmorphic landing page. The app demonstrates both past projects and in-app capabilities (virtual file system, terminal, code editor, window manager).

## Architecture

### Entry Point
- `lib/main.dart:10` — `main()` runs `PortfolioApp` with `MultiBlocProvider` providing all 4 cubits
- `lib/main_orchestrator.dart:15` — `MainOrchestrator` routes to the correct OS desktop/launcher based on `OSModeCubit` state; also handles mobile device simulation frame

### State Management (flutter_bloc)
| Cubit | File | Purpose |
|-------|------|---------|
| `OSModeCubit` | `lib/features/os_mode/cubit/os_mode_cubit.dart` | Switches between Windows/macOS/Linux/Android/iOS/Web |
| `WindowManagerCubit` | `lib/features/virtual_window/cubit/window_manager_cubit.dart` | Opens/closes/focuses/minimizes/moves virtual windows |
| `ThemeCubit` | `lib/features/theme/theme_cubit.dart` | Wallpaper selection + dark mode (persisted via SharedPreferences) |
| `FileSystemCubit` | `lib/features/file_system/cubit/file_system_cubit.dart` | Virtual filesystem: `cd`, `mkdir`, `touch`, tree traversal |

### Feature Modules (all under `lib/features/`)
| Feature | Description |
|---------|-------------|
| `boot/` | `BootScreen` (retro BIOS animation) → `LoginScreen` (profile + login button) |
| `desktop/` | `WindowsDesktop`, `MacDesktop`, `LinuxDesktop` — each has its own wallpaper, dock/taskbar/menu bar, and window manager |
| `mobile/` | `AndroidLauncher` & `IosLauncher` — app grid with status/nav bars |
| `web/` | `WebLauncher` — glassmorphic landing page with hero section + project grid |
| `virtual_window/` | Window manager: `VirtualWindowItem`, `VirtualWindow`, `BaseWindowFrame` (Win/Mac/Linux title bars), `WindowContentBuilder`, `WindowContent` |
| `apps/` | Widgets: `TerminalApp`, `CodeEditorApp`, `ProjectExplorer`, `SettingsApp`, `ExperienceApp`, `GalleryApp`, `MarkdownViewerApp`, `GithubStatusWidget`, `SpotifyWidget` |
| `apps/` | Services: `AppLauncherService` (routes taps to windows/external URLs), `GithubService` (Dio-based GitHub API) |
| `apps/` | Data: `AppType` enum, `ProjectModel` (hardcoded sample projects) |
| `file_system/` | Virtual FS: `FileNode`, `ProjectManifest` (freezed), `ProjectLoaderService` (loads from `assets/projects/*/manifest.json`) |
| `switcher/` | `OSSwitcherWidget` — floating bottom-right OS picker |
| `theme/` | `ThemeCubit` — wallpaper + dark mode |

### Virtual Window System
- `WindowContentType` enum: `profile`, `projectDetail`, `skills`, `experience`, `contact`, `webBrowser`, `terminal`, `code`, `settings`, `markdown`, `gallery`
- `AppLauncherService` (`lib/features/apps/app_launcher_service.dart`) maps `AppType` to either opening a `WindowContent` via `WindowManagerCubit` or launching external URLs (`url_launcher`)
- `WindowContentBuilder` (`lib/features/virtual_window/window_content_builder.dart`) maps `WindowContentType` to the actual widget

### Project Data (Assets)
- `assets/projects/<id>/manifest.json` — loaded by `ProjectLoaderService` into the virtual filesystem
- Current projects: `portfolio`, `ecommerce-app`, `task-manager`
- Format: `ProjectManifest` (`id`, `title`, `description`, `version`, `techStack`, `tags`, `repoUrl`, `liveUrl`, `iconPath`, `gallery`)

### Key Dependencies (pubspec.yaml)
- `flutter_bloc`, `equatable`, `dio`, `get_it`, `go_router` (not heavily used yet), `url_launcher`, `flutter_markdown`, `flutter_highlight`, `cached_network_image`, `shared_preferences`, `font_awesome_flutter`, `flutter_resizable_container`, `google_fonts`, `uuid`, `freezed` + `json_serializable`

### CI/CD
- `.github/workflows/deploy.yml` — builds to web on `production` branch push, deploys to GitHub Pages

### Lint/Analyze
- `analysis_options.yaml` — uses `package:flutter_lints/flutter.yaml`
- Run: `flutter analyze`

### Build & Run
- `flutter run -d chrome` — web dev
- `flutter build web --release` — production build

### Code Conventions
- Uses `flutter_lints` lint set
- State management: Bloc/Cubit pattern with `Equatable`
- File structure: feature-first under `lib/features/`
- Models: `freezed` for data classes with `fromJson`
- Assets: declared in `pubspec.yaml` under `flutter > assets`
- OS-specific UI: themed containers mimicking each platform's native look
