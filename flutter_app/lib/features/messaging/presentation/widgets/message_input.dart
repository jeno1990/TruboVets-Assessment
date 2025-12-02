import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

/// A text input widget for composing and sending messages.
/// Supports both text and image messages.
class MessageInput extends StatefulWidget {
  /// Callback when a text message is sent
  final void Function(String message) onSendText;

  /// Callback when an image is selected
  final void Function(String imagePath) onSendImage;

  /// Whether the send button should be disabled
  final bool isDisabled;

  const MessageInput({
    super.key,
    required this.onSendText,
    required this.onSendImage,
    this.isDisabled = false,
  });

  @override
  State<MessageInput> createState() => _MessageInputState();
}

class _MessageInputState extends State<MessageInput> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final ImagePicker _imagePicker = ImagePicker();
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _controller.removeListener(_onTextChanged);
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    final hasText = _controller.text.trim().isNotEmpty;
    if (hasText != _hasText) {
      setState(() => _hasText = hasText);
    }
  }

  void _handleSend() {
    if (_controller.text.trim().isEmpty || widget.isDisabled) return;

    widget.onSendText(_controller.text);
    _controller.clear();
    _focusNode.requestFocus();
  }

  Future<void> _handleImagePick() async {
    if (widget.isDisabled) return;

    final colorScheme = Theme.of(context).colorScheme;

    // Show bottom sheet to choose source
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: colorScheme.onSurfaceVariant.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              ListTile(
                leading: CircleAvatar(
                  backgroundColor: colorScheme.primaryContainer,
                  child: Icon(
                    Icons.camera_alt_rounded,
                    color: colorScheme.onPrimaryContainer,
                  ),
                ),
                title: const Text('Take Photo'),
                onTap: () => Navigator.pop(context, ImageSource.camera),
              ),
              ListTile(
                leading: CircleAvatar(
                  backgroundColor: colorScheme.secondaryContainer,
                  child: Icon(
                    Icons.photo_library_rounded,
                    color: colorScheme.onSecondaryContainer,
                  ),
                ),
                title: const Text('Choose from Gallery'),
                onTap: () => Navigator.pop(context, ImageSource.gallery),
              ),
            ],
          ),
        ),
      ),
    );

    if (source == null) return;

    try {
      final XFile? image = await _imagePicker.pickImage(
        source: source,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (image != null) {
        widget.onSendImage(image.path);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to pick image: $e'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: EdgeInsets.only(
        left: 8,
        right: 8,
        top: 8,
        bottom: MediaQuery.of(context).padding.bottom + 8,
      ),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Image picker button
          IconButton(
            onPressed: widget.isDisabled ? null : _handleImagePick,
            style: IconButton.styleFrom(
              foregroundColor: colorScheme.onSurfaceVariant,
            ),
            icon: const Icon(Icons.image_rounded),
            tooltip: 'Send image',
          ),
          // Text input
          Expanded(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 120),
              child: TextField(
                controller: _controller,
                focusNode: _focusNode,
                maxLines: null,
                textCapitalization: TextCapitalization.sentences,
                textInputAction: TextInputAction.send,
                onSubmitted: (_) => _handleSend(),
                decoration: InputDecoration(
                  hintText: 'Type a message...',
                  hintStyle: TextStyle(
                    color: colorScheme.onSurfaceVariant.withOpacity(0.6),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 4),
          // Send button
          IconButton(
            onPressed: (_hasText && !widget.isDisabled) ? _handleSend : null,
            style: IconButton.styleFrom(
              backgroundColor: (_hasText && !widget.isDisabled)
                  ? colorScheme.primary
                  : colorScheme.surfaceContainerHighest,
              foregroundColor: (_hasText && !widget.isDisabled)
                  ? colorScheme.onPrimary
                  : colorScheme.onSurfaceVariant.withOpacity(0.5),
              minimumSize: const Size(48, 48),
            ),
            icon: const Icon(Icons.send_rounded),
          ),
        ],
      ),
    );
  }
}
