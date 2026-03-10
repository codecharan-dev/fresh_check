import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:fresh_check/app/app_exports.dart';
import 'package:fresh_check/app/di/injection.dart';
import 'package:fresh_check/features/auth/presentation/bloc/login/login_bloc.dart';
import 'package:fresh_check/features/auth/presentation/bloc/login/login_event.dart';
import 'package:fresh_check/features/auth/presentation/bloc/login/login_state.dart';
import 'package:fresh_check/features/auth/presentation/widgets/auth_widgets.dart';
import 'package:fresh_check/shared/widgets/shared_widgets.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<LoginBloc>(),
      child: const _LoginView(),
    );
  }
}

class _LoginView extends StatelessWidget {
  const _LoginView();

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
      listenWhen: (prev, curr) =>
          curr.toastMessage != null &&
          prev.toastMessage != curr.toastMessage,
      listener: (context, state) {
        showToast(
          state.toastMessage!,
          context: context,
          position: StyledToastPosition.bottom,
          backgroundColor: AppColors.inputErrorBorder,
          textStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.textInverse,
              ),
          borderRadius: BorderRadius.circular(12),
          duration: const Duration(seconds: 3),
          animDuration: const Duration(milliseconds: 300),
          animation: StyledToastAnimation.slideFromBottom,
          reverseAnimation: StyledToastAnimation.slideToBottom,
        );
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: Column(
              children: [
                // ── Title ───────────────────────────────────────────
                Center(
                  child: Text(
                    'Sign in',
                    style:
                        Theme.of(context).textTheme.headlineLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                AppSizedBox.v8,

                // ── Subtitle ────────────────────────────────────────
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'New user? ',
                      style:
                          Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        // TODO: Navigate to sign up
                      },
                      child: Text(
                        'Create an account',
                        style:
                            Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                ),
                AppSizedBox.v32,

                // ── Email field ─────────────────────────────────────
                EmailField(
                  controller: _emailController,
                  onChanged: (value) => context
                      .read<LoginBloc>()
                      .add(LoginEvent.emailChanged(value)),
                ),
                AppSizedBox.v16,

                // ── Password field ──────────────────────────────────
                PasswordField(
                  controller: _passwordController,
                  onChanged: (value) => context
                      .read<LoginBloc>()
                      .add(LoginEvent.passwordChanged(value)),
                ),
                AppSizedBox.v12,

                // ── Forgot password ─────────────────────────────────
                Center(
                  child: ForgotPasswordButton(
                    onPressed: () {
                      // TODO: Navigate to forgot password
                    },
                  ),
                ),
                AppSizedBox.v32,

                // ── Login button ────────────────────────────────────
                LoginButton(
                  text: 'Login',
                  onPressed: () => context
                      .read<LoginBloc>()
                      .add(const LoginEvent.submitted()),
                ),
                AppSizedBox.v32,

                // ── OR divider ──────────────────────────────────────
                Row(
                  children: [
                    const Expanded(
                      child: Divider(color: AppColors.divider),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        'or',
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.copyWith(
                          color: AppColors.textDisabled,
                        ),
                      ),
                    ),
                    const Expanded(
                      child: Divider(color: AppColors.divider),
                    ),
                  ],
                ),
                AppSizedBox.v24,

                // ── Social login text ───────────────────────────────
                Center(
                  child: Text(
                    'Join With Your Favourite Social Media Account',
                    style:
                        Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: AppColors.textPrimary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                AppSizedBox.v20,

                // ── Social buttons ──────────────────────────────────
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SocialButton(
                      child: Text(
                        'G',
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge
                            ?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.googleRed,
                        ),
                      ),
                      onTap: () {
                        // TODO: Google sign in
                      },
                    ),
                    AppSizedBox.h16,
                    SocialButton(
                      child: const Icon(
                        Icons.facebook,
                        color: AppColors.facebookBlue,
                        size: 28,
                      ),
                      onTap: () {
                        // TODO: Facebook sign in
                      },
                    ),
                    AppSizedBox.h16,
                    SocialButton(
                      child: Text(
                        'X',
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge
                            ?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      onTap: () {
                        // TODO: X sign in
                      },
                    ),
                    AppSizedBox.h16,
                    SocialButton(
                      child: const Icon(
                        Icons.apple,
                        color: AppColors.textPrimary,
                        size: 28,
                      ),
                      onTap: () {
                        // TODO: Apple sign in
                      },
                    ),
                  ],
                ),
                AppSizedBox.v40,

                // ── Terms footer ────────────────────────────────────
                Center(
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                      children: [
                        const TextSpan(
                          text:
                              "By signing in with an account, you agree to SO's\n",
                        ),
                        TextSpan(
                          text: 'Terms of Service',
                          style: const TextStyle(
                            decoration: TextDecoration.underline,
                            color: AppColors.textPrimary,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              // TODO: Open Terms of Service
                            },
                        ),
                        const TextSpan(text: ' and '),
                        TextSpan(
                          text: 'Privacy Policy',
                          style: const TextStyle(
                            decoration: TextDecoration.underline,
                            color: AppColors.textPrimary,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              // TODO: Open Privacy Policy
                            },
                        ),
                        const TextSpan(text: '.'),
                      ],
                    ),
                  ),
                ),
                AppSizedBox.v24,
              ],
            ),
          ),
        ),
      ),
      ),
    );
  }

  static final _emailController = TextEditingController();
  static final _passwordController = TextEditingController();
}
