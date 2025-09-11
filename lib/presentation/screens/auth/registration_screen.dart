import 'dart:io';

import 'package:attendance_tracker/core/extensions/extensions.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../core/utils/utils.dart';
import '../../providers/providers.dart';
import '../../widgets/widgets.dart';

class RegistrationScreen extends HookConsumerWidget {
  const RegistrationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = useRef(GlobalKey<FormState>());
    final nameController = useTextEditingController();
    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();
    final confirmPasswordController = useTextEditingController();
    final imageFile = useState<File?>(null);
    final isLoading = useState(false);
    final obscurePassword = useState(true);
    final obscureConfirmPassword = useState(true);

    ref.listen(authNotifierProvider, (previous, next) {
      if (next.hasError) {
        context.showSnackBar('Registration failed: ${next.error}',
            isError: true);
      } else if (next.hasValue && next.value != null) {
        logger.i('Registration successful, redirecting to user home');
        ref
            .read(notificationNotifierProvider.notifier)
            .updateFcmToken(next.value!.id);
        context.go('/user/home');
      }
    });

    Future<String?> uploadImage(File file) async {
      try {
        logger.i('Uploading profile image');
        final ref = FirebaseStorage.instance
            .ref()
            .child('profile_images')
            .child('${DateTime.now().millisecondsSinceEpoch}.jpg');
        await ref.putFile(file);
        final url = await ref.getDownloadURL();
        logger.i('Profile image uploaded: $url');
        return url;
      } catch (e) {
        logger.e('Failed to upload image: $e');
        return null;
      }
    }

    Future<void> handleRegistration() async {
      context.hideKeyboard();
      if (!formKey.value.currentState!.validate()) return;

      isLoading.value = true;
      try {
        String? imageUrl;
        if (imageFile.value != null) {
          imageUrl = await uploadImage(imageFile.value!);
        }
        final fcmToken = ref.read(notificationNotifierProvider);
        logger.i('Registering user: ${emailController.text}');
        await ref.read(authNotifierProvider.notifier).register(
              nameController.text.trim(),
              emailController.text.trim(),
              passwordController.text.trim(),
              profileImageUrl: imageUrl,
              fcmToken: fcmToken,
            );
      } catch (e) {
        logger.e('Registration failed: $e');
        if (context.mounted) {
          context.showSnackBar('Registration failed: $e', isError: true);
        }
      } finally {
        isLoading.value = false;
      }
    }

    return FormContainer(
      title: 'Create Account',
      submitButton: CustomButton(
        text: 'Register',
        isLoading: isLoading.value,
        onPressed: handleRegistration,
      ),
      footer: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("Already have an account?"),
          TextButton(
            onPressed: () => context.pop(),
            child: const Text('Sign in'),
          ),
        ],
      ),
      children: [
        Form(
          key: formKey.value,
          child: Column(
            children: [
              ImagePickerWidget(
                imageFile: imageFile.value,
                onImageSelected: (file) => imageFile.value = file,
              ),
              const SizedBox(height: 16),
              InputField(
                labelText: 'Full Name',
                controller: nameController,
                validator: Validators.validateName,
                onChanged: (_) => formKey.value.currentState?.validate(),
              ),
              const SizedBox(height: 16),
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
              InputField(
                labelText: 'Confirm Password',
                controller: confirmPasswordController,
                obscureText: obscureConfirmPassword.value,
                validator: (value) => Validators.validateConfirmPassword(
                  value,
                  passwordController.text,
                ),
                onChanged: (_) => formKey.value.currentState?.validate(),
                suffixIcon: IconButton(
                  icon: Icon(
                    obscureConfirmPassword.value
                        ? Icons.visibility_off
                        : Icons.visibility,
                  ),
                  onPressed: () => obscureConfirmPassword.value =
                      !obscureConfirmPassword.value,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
