import 'package:cartify/core/constants/app_colors.dart';
import 'package:cartify/core/enums/snackbar_message_type.dart';
import 'package:flutter/material.dart';

class ToastManager {
  static OverlayEntry? _currentToast;

  static void show({
    required BuildContext context,
    required String message,
    SnackBarMessageType type = SnackBarMessageType.info,
    Duration duration = const Duration(seconds: 3),
    VoidCallback? onTap,
  }) {
    dismiss();

    final toastData = _getToastData(type);

    final overlay = Overlay.maybeOf(context);

    if (overlay == null) {
      debugPrint(
        'ToastManager: No Overlay found in context. Cannot show toast.',
      );
      return;
    }

    _currentToast = OverlayEntry(
      builder:
          (context) => _ToastWidget(
            message: message,
            backgroundColor: toastData.backgroundColor,
            icon: toastData.icon,
            iconColor: toastData.iconColor,
            onTap: onTap,
          ),
    );

    overlay.insert(_currentToast!);

    Future.delayed(duration, () {
      dismiss();
    });
  }

  static void dismiss() {
    if (_currentToast != null) {
      try {
        _currentToast?.remove();
      } catch (e) {
        // Toast already removed
      }
      _currentToast = null;
    }
  }

  static _ToastData _getToastData(SnackBarMessageType type) {
    switch (type) {
      case SnackBarMessageType.success:
        return _ToastData(
          backgroundColor: AppColors.green500,
          icon: Icons.check_circle_rounded,
          iconColor: Colors.white,
        );
      case SnackBarMessageType.error:
        return _ToastData(
          backgroundColor: AppColors.error,
          icon: Icons.error_rounded,
          iconColor: Colors.white,
        );
      case SnackBarMessageType.warning:
        return _ToastData(
          backgroundColor: Colors.orange.shade600,
          icon: Icons.warning_rounded,
          iconColor: Colors.white,
        );
      case SnackBarMessageType.info:
        return _ToastData(
          backgroundColor: AppColors.primary,
          icon: Icons.info_rounded,
          iconColor: Colors.white,
        );
      case SnackBarMessageType.none:
        return _ToastData(
          backgroundColor: Colors.black87,
          icon: null,
          iconColor: Colors.white,
        );
    }
  }
}

class _ToastData {
  final Color backgroundColor;
  final IconData? icon;
  final Color iconColor;

  _ToastData({
    required this.backgroundColor,
    this.icon,
    required this.iconColor,
  });
}

class _ToastWidget extends StatefulWidget {
  final String message;
  final Color backgroundColor;
  final IconData? icon;
  final Color iconColor;
  final VoidCallback? onTap;

  const _ToastWidget({
    required this.message,
    required this.backgroundColor,
    this.icon,
    required this.iconColor,
    this.onTap,
  });

  @override
  State<_ToastWidget> createState() => _ToastWidgetState();
}

class _ToastWidgetState extends State<_ToastWidget>
    with SingleTickerProviderStateMixin {
  static const double _maxToastHeight = 96;
  static const int _maxMessageLines = 3;

  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _opacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: MediaQuery.of(context).padding.top + 16,
      left: 16,
      right: 16,
      child: SlideTransition(
        position: _slideAnimation,
        child: FadeTransition(
          opacity: _opacityAnimation,
          child: Material(
            color: Colors.transparent,
            child: GestureDetector(
              onTap: () {
                widget.onTap?.call();
                ToastManager.dismiss();
              },
              child: Container(
                constraints: const BoxConstraints(maxHeight: _maxToastHeight),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                decoration: BoxDecoration(
                  color: widget.backgroundColor,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.15),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    if (widget.icon != null) ...[
                      Icon(widget.icon, color: widget.iconColor, size: 22),
                      const SizedBox(width: 12),
                    ],
                    Expanded(
                      child: Text(
                        widget.message,
                        maxLines: _maxMessageLines,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          height: 1.4,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: () => ToastManager.dismiss(),
                      child: Icon(
                        Icons.close,
                        color: Colors.white.withValues(alpha: 0.8),
                        size: 18,
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
