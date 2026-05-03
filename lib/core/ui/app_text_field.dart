import 'package:flutter/material.dart';

/// TropicaGuide design-system text field.
///
/// Thin wrapper over [TextFormField] that enforces consistent styling and
/// provides a built-in password-reveal toggle for [obscureText] fields.
/// Validation errors display inline with [AutovalidateMode.onUserInteraction].
class AppTextField extends StatefulWidget {
  /// Creates an [AppTextField].
  const AppTextField({
    required this.controller,
    required this.label,
    super.key,
    this.hint,
    this.validator,
    this.obscureText = false,
    this.keyboardType,
    this.textInputAction,
    this.onFieldSubmitted,
    this.focusNode,
    this.autovalidateMode = AutovalidateMode.onUserInteraction,
  });

  /// Controls the text being edited.
  final TextEditingController controller;

  /// Floating label text.
  final String label;

  /// Placeholder text shown when the field is empty.
  final String? hint;

  /// Validation function. Return a non-null string to show an error.
  final FormFieldValidator<String>? validator;

  /// When `true`, input is obscured and a reveal toggle is shown.
  final bool obscureText;

  /// The type of keyboard to use.
  final TextInputType? keyboardType;

  /// The action button on the keyboard.
  final TextInputAction? textInputAction;

  /// Called when the user submits the field.
  final ValueChanged<String>? onFieldSubmitted;

  /// Optional focus node for programmatic focus management.
  final FocusNode? focusNode;

  /// When to auto-validate. Defaults to [AutovalidateMode.onUserInteraction].
  final AutovalidateMode autovalidateMode;

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  bool _obscured = true;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: widget.label,
      textField: true,
      child: TextFormField(
        controller: widget.controller,
        focusNode: widget.focusNode,
        obscureText: widget.obscureText && _obscured,
        keyboardType: widget.keyboardType,
        textInputAction: widget.textInputAction,
        onFieldSubmitted: widget.onFieldSubmitted,
        autovalidateMode: widget.autovalidateMode,
        validator: widget.validator,
        decoration: InputDecoration(
          labelText: widget.label,
          hintText: widget.hint,
          suffixIcon: widget.obscureText
              ? IconButton(
                  tooltip: _obscured ? 'Show password' : 'Hide password',
                  icon: Icon(
                    _obscured
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                  ),
                  onPressed: () => setState(() => _obscured = !_obscured),
                )
              : null,
        ),
      ),
    );
  }
}
