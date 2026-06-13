enum ChatRole {
  user,
  assistant,
  system;

  bool get isUser => this == ChatRole.user;
  bool get isAssistant => this == ChatRole.assistant;
}
