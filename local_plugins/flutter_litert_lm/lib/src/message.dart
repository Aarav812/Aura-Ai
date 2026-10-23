import 'content.dart';
import 'tool.dart';

/// Role of a message participant.
enum LiteLmRole { user, model, tool }

/// A message in a conversation.
class LiteLmMessage {
  final LiteLmRole role;
  final String text;
  final List<LiteLmContent> contents;
  final List<LiteLmToolCall> toolCalls;

  /// Optional model output channels, such as `thought` for reasoning models.
  final Map<String, String> channels;

  LiteLmMessage({
    required this.role,
    this.text = '',
    this.contents = const [],
    this.toolCalls = const [],
    this.channels = const {},
  });

  /// Create a user message from text.
  factory LiteLmMessage.user(String text) => LiteLmMessage(
        role: LiteLmRole.user,
        text: text,
        contents: [LiteLmContent.text(text)],
      );

  /// Create a model message from text.
  factory LiteLmMessage.model(String text) => LiteLmMessage(
        role: LiteLmRole.model,
        text: text,
        contents: [LiteLmContent.text(text)],
      );

  /// Create a user message with mixed contents (text, images, audio).
  factory LiteLmMessage.userMultimodal(List<LiteLmContent> contents) =>
      LiteLmMessage(
        role: LiteLmRole.user,
        contents: contents,
      );

  /// Create a tool response message.
  factory LiteLmMessage.toolResponse(String name, String result) =>
      LiteLmMessage(
        role: LiteLmRole.tool,
        contents: [LiteLmContent.toolResponse(name, result)],
      );

  factory LiteLmMessage.fromMap(Map<String, dynamic> map) {
    final toolCalls = (map['toolCalls'] as List<dynamic>?)
            ?.map((e) => LiteLmToolCall.fromMap(Map<String, dynamic>.from(e)))
            .toList() ??
        [];
    final rawChannels = map['channels'];
    final channels = rawChannels is Map
        ? rawChannels.map(
            (key, value) => MapEntry(key.toString(), value?.toString() ?? ''),
          )
        : <String, String>{};
    return LiteLmMessage(
      role: LiteLmRole.values.byName(map['role'] as String),
      text: map['text'] as String? ?? '',
      toolCalls: toolCalls,
      channels: channels,
    );
  }

  Map<String, dynamic> toMap() => {
        'role': role.name,
        'text': text,
        'contents': contents.map((c) => c.toMap()).toList(),
        if (channels.isNotEmpty) 'channels': channels,
      };
}
