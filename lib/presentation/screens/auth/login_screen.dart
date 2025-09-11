import 'package:attendance_tracker/core/extensions/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../core/constants/constants.dart';
import '../../../core/utils/utils.dart';
import '../../providers/providers.dart';
import '../../widgets/widgets.dart';

class LoginScreen extends HookConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = useRef(GlobalKey<FormState>());
    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();
    final isLoading = useState(false);
    final obscurePassword = useState(true);

    ref.listen(authNotifierProvider, (previous, next) {
      if (next.hasError) {
        context.showSnackBar('Login failed: ${next.error}', isError: true);
      } else if (next.hasValue && next.value != null) {
        final user = next.value!;
        logger.i('Redirecting user: ${user.id} with role: ${user.role}');
        if (user.role == UserRole.admin) {
          context.go('/admin/dashboard');
        } else {
          context.go('/user/home');
        }
      }
    });

    Future<void> handleLogin() async {
      context.hideKeyboard();
      if (!formKey.value.currentState!.validate()) return;

      isLoading.value = true;
      try {
        logger.i('Login attempt for email: ${emailController.text}');
        await ref.read(authNotifierProvider.notifier).signIn(
              emailController.text.trim(),
              passwordController.text.trim(),
            );
      } catch (e) {
        logger.e('Login failed: $e');
        if (context.mounted) {
          context.showSnackBar(
            'Login failed: $e',
            isError: true,
          );
        }
      } finally {
        isLoading.value = false;
      }
    }

    return FormContainer(
      title: 'Sign In',
      submitButton: CustomButton(
        text: 'Login',
        isLoading: isLoading.value,
        onPressed: handleLogin,
      ),
      footer: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("Don't have an account?"),
          TextButton(
            onPressed: () => context.push('/register'),
            child: const Text('Sign up'),
          ),
        ],
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
              const SizedBox(height: 16),
              InputField(
                labelText: 'Password',
                controller: passwordController,
                obscureText: obscurePassword.value,
                validator: Validators.validatePassword,
                onChanged: (_) => formKey.value.currentState?.validate(),
                suffixIcon: IconButton(
                  icon: Icon(
                    obscurePassword.value
                        ? Icons.visibility_off
                        : Icons.visibility,
                  ),
                  onPressed: () =>
                      obscurePassword.value = !obscurePassword.value,
                ),
              ),
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => context.push('/forgot-password'),
                  child: const Text('Forgot Password?'),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
