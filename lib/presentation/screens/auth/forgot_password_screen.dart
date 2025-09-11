import 'package:attendance_tracker/core/extensions/extensions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../core/utils/utils.dart';
import '../../widgets/widgets.dart';

class ForgotPasswordScreen extends HookConsumerWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = useRef(GlobalKey<FormState>());
    final emailController = useTextEditingController();
    final isLoading = useState(false);

    Future<void> handleResetPassword() async {
      context.hideKeyboard();
      if (!formKey.value.currentState!.validate()) return;

      isLoading.value = true;
      try {
        logger.i('Sending password reset email to: ${emailController.text}');
        await FirebaseAuth.instance.sendPasswordResetEmail(
          email: emailController.text.trim(),
        );
        if (context.mounted) {
          context.showSnackBar('Password reset email sent!');
          context.pop();
        }
      } catch (e) {
        logger.e('Password reset failed: $e');
        if (context.mounted) {
          context.showSnackBar('Error: $e', isError: true);
        }
      } finally {
        isLoading.value = false;
      }
    }

    return FormContainer(
      title: 'Reset Password',
      submitButton: CustomButton(
        text: 'Send Reset Link',
        isLoading: isLoading.value,
        onPressed: handleResetPassword,
      ),
      footer: TextButton(
        onPressed: () => context.pop(),
        child: const Text('Back to Sign In'),
      ),
      children: [
        Form(
          key: formKey.value,
          child: Column(
            children: [
              InputField(
                labelText: 'Email',
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                validator: Validators.validateEmail,
                onChanged: (_) => formKey.value.currentState?.validate(),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
