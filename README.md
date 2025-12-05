# Messaging App with Embedded Internal Tools Dashboard

## Quick Start

### Prerequisites

- **Flutter SDK** 3.9 or higher
- **Node.js** 18+ and npm
- **Angular CLI** (`npm install -g @angular/cli`)
- iOS Simulator or Android Emulator

### Running the Project

#### Step 1: Start the Angular Dashboard Server

```bash
cd webpage
npm install
npm start
```

The server will start at `http://0.0.0.0:4200` (accessible from both iOS and Android emulators).

#### Step 2: Run the Flutter App

Open a new terminal:

```bash
cd flutter_app
flutter pub get
flutter run
```

The app automatically detects the platform and uses the correct URL from the app constants.

## Project Overview, Assumptions & Decisions

This project demonstrates cross-technology integration between:

1. **Flutter** - Native mobile messaging interface with persistent storage
2. **Angular + Tailwind CSS** - Internal tools dashboard embedded via WebView

### Why This Architecture?

The project uses a **minimalistic Clean Architecture** approach for the Flutter app. Traditional Clean Architecture includes layers like DTOs, Use Cases, and Mappers, which add boilerplate. For this project's scope, I simplified by:

- Removing Use Cases - Direct repository access from Cubits
- Removing DTOs - Domain entities used directly
- Keeping Core Separation - Domain, Data, and Presentation layers remain distinct
- No Dependency Injection manager - Its overkill for few clases

This balance maintains testability and separation of concerns while avoiding over-engineering.

---

## Architecture

### Flutter App Structure

```
flutter_app/lib/
├── core/
│   ├── constants/
│   └── theme/              # Light/Dark theme definitions & ThemeCubit
├── data/
│   ├── adapters/           # Hive TypeAdapter
│   └── repositories/       # Hive implementation
├── domain/
│   ├── entities/           # Message entity
│   └── repositories/       # Repository interface
└── presentation/
    ├── pages/
    ├── state/
    └── widgets/
```

### Angular Dashboard Structure

```
webpage/src/app/
├── sidebar/
├── ticket-viewer/
├── knowledgebase/
├── live-logs/
└── mock-data.service.ts
```

---

## Implemented Features

### Flutter App

- Native Chat UI
- Timestamps - Human-readable timestamps (today shows time only)
- Auto-Scroll
- Simulated Agent - Random responses from preset list with typing indicator
- Image Messages
- Emoji Support
- Message Persistence - Chat history saved with Hive
- Dark Mode
- WebView Dashboard
- Bottom Navigation

### Angular Dashboard

- Ticket Viewer - Table with dummy tickets, filterable by status (Open/In Progress/Closed)
- Knowledgebase Editor - Custom markdown editor with live preview (ngx-markdown)
- Live Logs Panel - Simulated real-time logs with auto-scroll and smooth animation
- Sidebar Navigation - Angular routing between modules
- Responsive Design - Mobile-first, optimized for WebView viewport

---

## Bonus Features Implemented

- Message persistence (Hive)
- Emoji support (native keyboard)
- Image messages (camera + gallery)
- Dark mode toggle
- Log animations in Live Logs panel (simple fade in animation)
- Markdown preview in Knowledgebase editor
- Typing indicator animation
- WebView error handling with retry
- Unit tests for Flutter app (Cubits, Entities, Repository)

---

## Testing

Unit tests are included for the Flutter app covering:

- **Message Entity** - Factory methods, equality, getters
- **MessageRepository** - CRUD operations, edge cases
- **MessageCubit** - State management with mocked repository
- **ThemeCubit** - Theme switching and toggles

Run tests:

```bash
cd flutter_app
flutter test
```

---

## Screenshots

### Flutter App

| Chat Page                               | Dark Mode                               |
| --------------------------------------- | --------------------------------------- |
| ![Chat Page](screenshots/chat_page.png) | ![Dark Mode](screenshots/dark_mode.png) |

### Angular Dashboard (in WebView)

| Dashboard                                       | Knowledgebase Editor                                   |
| ----------------------------------------------- | ------------------------------------------------------ |
| ![Dashboard](screenshots/webpage_dashboard.png) | ![Knowledgebase](screenshots/knowledgebase_editor.png) |

| Live Logs Panel                                  |
| ------------------------------------------------ |
| ![Live Logs](screenshots/logs_screen_mobile.png) |

### Error Handling

| Connection Error                                              |
| ------------------------------------------------------------- |
| ![Connection Error](screenshots/connection_error_message.png) |

---
