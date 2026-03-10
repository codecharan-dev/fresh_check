import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fresh_check/app/app_exports.dart';
import 'package:fresh_check/shared/widgets/inputs/bloc/password_field/password_visibility_bloc.dart';
import 'package:fresh_check/shared/widgets/inputs/bloc/password_field/password_visibility_event.dart';
import 'package:fresh_check/shared/widgets/inputs/bloc/password_field/password_visibility_state.dart';

class PasswordField extends StatelessWidget {
  const PasswordField({
    super.key,
    required this.controller,
    this.focusNode,
    this.validator,
    this.onChanged,
    this.onEditingComplete,
    this.hintText = 'Password',
    this.labelText,
    this.autovalidateMode,
    this.textInputAction = TextInputAction.done,
    this.enabled = true,
    this.errorText,
  });

  final TextEditingController controller;
  final FocusNode? focusNode;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onEditingComplete;
  final String? hintText;
  final String? labelText;
  final AutovalidateMode? autovalidateMode;
  final TextInputAction textInputAction;
  final bool enabled;
  final String? errorText;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PasswordVisibilityBloc(),
      child: BlocBuilder<PasswordVisibilityBloc, PasswordVisibilityState>(
        builder: (context, state) {
          final obscureText = state is PasswordObscured;
          return TextFormField(
            controller: controller,
            focusNode: focusNode,
            obscureText: obscureText,
            keyboardType: TextInputType.visiblePassword,
            textInputAction: textInputAction,
            autocorrect: false,
            enableSuggestions: false,
            enabled: enabled,
            validator: validator,
            onChanged: onChanged,
            onEditingComplete: onEditingComplete,
            autovalidateMode: autovalidateMode,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.textPrimary,
            ),
            decoration: InputDecoration(
              hintText: hintText,
              labelText: labelText,
              hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.textDisabled,
              ),
              prefixIcon: const Icon(
                Icons.lock_outline,
                color: AppColors.textDisabled,
                size: 20,
              ),
              suffixIcon: IconButton(
                onPressed: () => context
                    .read<PasswordVisibilityBloc>()
                    .add(const PasswordVisibilityEvent.toggled()),
                icon: Icon(
                  obscureText
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  color: AppColors.textDisabled,
                  size: 20,
                ),
              ),
              filled: true,
              fillColor: AppColors.inputFill,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
              border: _border(),
              enabledBorder: _border(),
              focusedBorder: _border(AppColors.primary),
              errorBorder: _border(AppColors.inputErrorBorder),
              focusedErrorBorder: _border(AppColors.inputErrorBorder),
              errorText: errorText,
              errorMaxLines: 2,
            ),
          );
        },
      ),
    );
  }

  OutlineInputBorder _border([Color? color]) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: color != null
          ? BorderSide(color: color, width: 1.5)
          : BorderSide.none,
    );
  }
}
