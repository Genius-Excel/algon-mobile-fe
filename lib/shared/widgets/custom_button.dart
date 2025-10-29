import 'package:flutter/material.dart';

enum ButtonVariant { primary, secondary, outline, text }

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final ButtonVariant variant;
  final bool isLoading;
  final bool isFullWidth;
  final Widget? icon;
  final IconData? iconData;
  final IconPosition iconPosition;
  final double? width;
  final double? height;
  final Color? backgroundColor;
  final Color? textColor;
  final double fontSize;
  final FontWeight fontWeight;

  const CustomButton({
    super.key,
    required this.text,
    this.onPressed,
    this.variant = ButtonVariant.primary,
    this.isLoading = false,
    this.isFullWidth = false,
    this.icon,
    this.iconData,
    this.iconPosition = IconPosition.right,
    this.width,
    this.height,
    this.backgroundColor,
    this.textColor,
    this.fontSize = 16,
    this.fontWeight = FontWeight.bold,
  });

  @override
  Widget build(BuildContext context) {
    final buttonStyle = _getButtonStyle();
    final textStyle = _getTextStyle();

    Widget buttonChild = isLoading
        ? const SizedBox(
            height: 20,
            width: 20,
            child: CircularProgressIndicator.adaptive(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          )
        : Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: _buildButtonContent(textStyle),
          );

    final buttonWidget = ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: buttonStyle,
      child: isFullWidth
          ? SizedBox(width: double.infinity, child: buttonChild)
          : buttonChild,
    );

    if (width != null || height != null) {
      return SizedBox(
        width: width,
        height: height,
        child: buttonWidget,
      );
    }

    return buttonWidget;
  }

  List<Widget> _buildButtonContent(TextStyle textStyle) {
    final hasIcon = icon != null || iconData != null;
    final buttonText = Text(text, style: textStyle);

    if (!hasIcon) return [buttonText];

    final iconWidget = icon ?? Icon(iconData, color: textStyle.color, size: 20);

    if (iconPosition == IconPosition.left) {
      return [iconWidget, const SizedBox(width: 8), buttonText];
    } else {
      return [buttonText, const SizedBox(width: 8), iconWidget];
    }
  }

  ButtonStyle _getButtonStyle() {
    switch (variant) {
      case ButtonVariant.primary:
        return ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? const Color(0xFF0D9488),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        );
      case ButtonVariant.secondary:
        return ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? const Color(0xFF10B981),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        );
      case ButtonVariant.outline:
        return ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          foregroundColor: textColor ?? const Color(0xFF0D9488),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(
              color: backgroundColor ?? const Color(0xFF0D9488),
              width: 2,
            ),
          ),
          elevation: 0,
        );
      case ButtonVariant.text:
        return TextButton.styleFrom(
          foregroundColor: textColor ?? const Color(0xFF0D9488),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        );
    }
  }

  TextStyle _getTextStyle() {
    final color =
        variant == ButtonVariant.outline || variant == ButtonVariant.text
            ? (textColor ?? const Color(0xFF0D9488))
            : (textColor ?? Colors.white);

    return TextStyle(
      color: color,
      fontSize: fontSize,
      fontWeight: fontWeight,
    );
  }
}

enum IconPosition { left, right }
