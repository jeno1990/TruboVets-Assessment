# Internal Tools Dashboard (Angular)

This is the Angular-based Internal Tools Dashboard for the TurboVets Assessment. It is designed to be embedded within a Flutter WebView but can also be run standalone.

## Features
- **Ticket Viewer**: View and filter support tickets.
- **Knowledgebase Editor**: Create and preview markdown content.
- **Live Logs**: Monitor real-time system logs.
- **Responsive Design**: Mobile-friendly layout with collapsible sidebar.

## Setup Instructions

### Prerequisites
- Node.js (v16 or higher)
- npm

### Running the Angular App
1. Navigate to the `webpage` directory:
   ```bash
   cd webpage
   ```
2. Install dependencies (if not already installed):
   ```bash
   npm install
   ```
3. Start the development server:
   ```bash
   npx ng serve --port 4200
   ```
4. Open your browser to `http://localhost:4200`.

## Integration with Flutter

To embed this dashboard in the Flutter app:

1. Ensure the Angular app is running on port 4200.
2. In your Flutter app, use `webview_flutter` or a similar plugin.
3. Set the initial URL based on your target device:
   - **iOS Simulator / Desktop**: `http://localhost:4200`
   - **Android Emulator**: `http://10.0.2.2:4200`
   - **Physical Device**: Use your computer's local IP address (e.g., `http://192.168.1.x:4200`).

### Example Flutter Code
```dart
WebView(
  initialUrl: 'http://localhost:4200',
  javascriptMode: JavascriptMode.unrestricted,
)
```

## Assumptions & Notes
- The "Save" button in the Knowledgebase Editor is a mock action and does not persist data to a backend.
- Live Logs are simulated using random data.
- Tailwind CSS is used for styling.
