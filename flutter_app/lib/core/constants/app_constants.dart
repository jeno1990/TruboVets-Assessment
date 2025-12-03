/// App-wide constants for the messaging application.
class AppConstants {
  AppConstants._();

  /// App name displayed in various places
  static const String appName = 'TurboVets';

  /// Simulated agent response delay range (in milliseconds)
  static const int minResponseDelay = 2000;
  static const int maxResponseDelay = 3000;

  /// Preset support agent responses for simulation
  static const List<String> agentResponses = [
    "Thanks for reaching out! How can I help you today?",
    "I understand your concern. Let me look into that for you.",
    "That's a great question! Here's what I can tell you...",
    "I'm checking our system now. One moment please.",
    "Thank you for your patience. I've found the information you need.",
    "Is there anything else I can help you with?",
    "I've made a note of that. Our team will follow up shortly.",
    "Got it! I'll make sure this gets resolved for you.",
    "Let me connect you with the right department for this.",
    "Thanks for the details. This helps us serve you better!",
    "I see what you mean. Let me explain how that works.",
    "That's been updated in our system. You should be all set!",
    "I appreciate your feedback. We're always looking to improve.",
    "Just to confirm - is there anything else you'd like to add?",
    "Perfect! I've processed that request for you.",
  ];

  /// Navigation labels
  static const String messagesLabel = 'Messages';
  static const String dashboardLabel = 'Dashboard';

  /// WebView URL for the Angular dashboard
  /// Use localhost for iOS simulator, 10.0.2.2 for Android emulator
  static const String dashboardUrlIOS = 'http://localhost:4200/tickets';
  static const String dashboardUrlAndroid = 'http://10.0.2.2:4200/tickets';
}
