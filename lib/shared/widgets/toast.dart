import 'package:flutter/material.dart';
import 'package:algon_mobile/core/service_exceptions/api_exceptions.dart';

class Toast {
  static void show(
    String? msg,
    BuildContext context, {
    String? title,
    int duration = 5,
    bool? forceDisplay,
  }) {
    if (forceDisplay ?? context.mounted) {
      _showToast(
        context,
        title ?? 'Success',
        msg ?? '',
        Icons.check_circle_outline,
        const Color(0xFF25D366),
        duration,
      );
    }
  }

  static void success(
    String? msg,
    BuildContext context, {
    String? title,
    int duration = 5,
    bool? forceDisplay,
  }) {
    if (forceDisplay ?? context.mounted) {
      _showToast(
        context,
        title ?? 'Success',
        msg ?? '',
        Icons.check_circle_outline,
        const Color(0xFF25D366),
        duration,
      );
    }
  }

  static void error(
    String? msg,
    BuildContext context, {
    String? title,
    int duration = 5,
    bool? forceDisplay,
  }) {
    if (forceDisplay ?? context.mounted) {
      _showToast(
        context,
        title ?? 'Error',
        msg ?? '',
        Icons.error_outline,
        const Color(0xFFEB0000),
        duration,
      );
    }
  }

  static void formError(
    BuildContext context, {
    int duration = 5,
    bool? forceDisplay,
  }) {
    if (forceDisplay ?? context.mounted) {
      _showToast(
        context,
        "Error",
        "Fix highlighted errors",
        Icons.error_outline,
        const Color(0xFFEB0000),
        duration,
      );
    }
  }

  static void apiError(
    ApiExceptions exception,
    BuildContext context, {
    String? title,
    int duration = 5,
  }) {
    if (context.mounted) {
      _showToast(
        context,
        title ?? 'Error',
        ApiExceptions.getErrorMessage(exception),
        Icons.error_outline,
        const Color(0xFFEB0000),
        duration,
      );
    }
  }

  static void info(
    String? msg,
    BuildContext context, {
    String? title,
    int duration = 5,
  }) {
    if (context.mounted) {
      _showToast(
        context,
        title ?? 'Info',
        msg ?? '',
        Icons.info_outline,
        const Color(0xFFF59300),
        duration,
      );
    }
  }

  static void _showToast(
    BuildContext context,
    String title,
    String body,
    IconData icon,
    Color iconColor,
    int seconds,
  ) {
    final overlayState = Overlay.of(context);
    final duration = Duration(seconds: seconds);

    late OverlayEntry overlayEntry;

    overlayEntry = OverlayEntry(
      builder: (overlayContext) {
        return _ToastWidget(
          title: title,
          body: body,
          icon: icon,
          iconColor: iconColor,
          duration: duration,
          onDismiss: () {
            if (overlayEntry.mounted) {
              overlayEntry.remove();
            }
          },
        );
      },
    );

    overlayState.insert(overlayEntry);

    // Remove the toast after the specified duration
    Future.delayed(duration).then((_) {
      if (overlayEntry.mounted) {
        overlayEntry.remove();
      }
    });
  }
}

class _ToastWidget extends StatefulWidget {
  final String title;
  final String body;
  final IconData icon;
  final Color iconColor;
  final Duration duration;
  final VoidCallback onDismiss;

  const _ToastWidget({
    required this.title,
    required this.body,
    required this.icon,
    required this.iconColor,
    required this.duration,
    required this.onDismiss,
  });

  @override
  State<_ToastWidget> createState() => _ToastWidgetState();
}

class _ToastWidgetState extends State<_ToastWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.0, -1.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Positioned(
      top: MediaQuery.of(context).padding.top,
      left: 0,
      right: 0,
      child: SlideTransition(
        position: _slideAnimation,
        child: GestureDetector(
          onTap: () {
            _controller.reverse().then((_) {
              widget.onDismiss();
            });
          },
          child: Material(
            color: Colors.transparent,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                decoration: BoxDecoration(
                  color: colorScheme.surface,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: colorScheme.outline.withOpacity(0.6),
                      blurRadius: 10.0,
                      spreadRadius: 1.0,
                      offset: const Offset(0.0, 0.0),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(widget.icon,
                          color: widget.iconColor, size: 32.0),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              widget.title,
                              style: textTheme.labelMedium?.copyWith(
                                color: widget.iconColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 4.0),
                            Text(
                              widget.body,
                              style: textTheme.bodyMedium,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
