import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quick_chat/presentation/cubit/auth_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MobileForgotPasswordView extends StatefulWidget {
  const MobileForgotPasswordView({Key? key}) : super(key: key);

  @override
  State<MobileForgotPasswordView> createState() =>
      _MobileForgotPasswordViewState();
}

class _MobileForgotPasswordViewState extends State<MobileForgotPasswordView> {
  late GlobalKey<FormState> _formKey;
  late TextEditingController _emailController;

  @override
  void initState() {
    _formKey = GlobalKey<FormState>();
    _emailController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is ResetPasswordSuccess) {
          Get.defaultDialog(
            title: 'Reset Password',
            content: Text(state.message, textAlign: TextAlign.center),
            textConfirm: 'Ok',
            onConfirm: () => Get.back(),
          );
        } else if (state is ResetPasswordError) {
          Get.defaultDialog(
            title: 'Reset Password',
            content: Text(state.message, textAlign: TextAlign.center),
            textConfirm: 'Ok',
            onConfirm: () => Get.back(),
          );
        }
      },
      child: Form(
        key: _formKey,
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 320),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 72, bottom: 16),
                    height: 96,
                    width: 96,
                    alignment: Alignment.center,
                    child: Icon(
                      Icons.lock_rounded,
                      color: context.theme.colorScheme.primary,
                      size: 42,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(48),
                      border: Border(
                        bottom: BorderSide(
                          color: context.theme.colorScheme.primary,
                        ),
                        left: BorderSide(
                          color: context.theme.colorScheme.primary,
                        ),
                        right: BorderSide(
                          color: context.theme.colorScheme.primary,
                        ),
                        top: BorderSide(
                          color: context.theme.colorScheme.primary,
                        ),
                      ),
                    ),
                  ),
                  Text(
                    'Forgot password?',
                    style: context.theme.textTheme.headline5!.copyWith(
                      color: context.theme.colorScheme.onBackground,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "No worries, we'll send you reset instructions",
                    style: context.theme.textTheme.bodyText1!.copyWith(
                      color: context.theme.colorScheme.onBackground,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _emailController,
                    validator: (value) {
                      return value != null && value.isEmail && value.isNotEmpty
                          ? null
                          : 'Please enter your email address';
                    },
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.done,
                    decoration: InputDecoration(
                      focusedErrorBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: context.theme.colorScheme.primary,
                        ),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: context.theme.colorScheme.primary,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: context.theme.colorScheme.primary,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: context.theme.colorScheme.primary,
                        ),
                      ),
                      hintText: 'Email Address',
                      prefixIcon: Icon(
                        Icons.email_rounded,
                        color: context.theme.colorScheme.primary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      fixedSize: const Size(double.maxFinite, 50),
                    ),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        await context
                            .read<AuthCubit>()
                            .resetPassword(_emailController.text);
                      }
                    },
                    child: const Text('Reset password'),
                  ),
                  const SizedBox(height: 16),
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: SizedBox(
                      width: double.infinity,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Icon(Icons.arrow_back_rounded),
                          const SizedBox(width: 4),
                          Text('Back to sign in',
                              style: context.textTheme.bodyText2)
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
    );
  }
}
