import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BuildLoginIllustration extends StatelessWidget {
  const BuildLoginIllustration({
    Key? key,
    required this.emailController,
    required this.passwordController,
  }) : super(key: key);

  final TextEditingController emailController;
  final TextEditingController passwordController;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 40, bottom: 20),
          child: SizedBox(
            child: Image(
              alignment: Alignment.topCenter,
              image: AssetImage('assets/images/login.png'),
            ),
          ),
        ),
        TextFormField(
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          controller: emailController,
          validator: (value) {
            return value != null && value.isEmail && value.isNotEmpty
                ? null
                : 'Please enter your email address';
          },
          decoration: InputDecoration(
            errorBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: context.theme.colorScheme.primary,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
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
        TextFormField(
          textInputAction: TextInputAction.done,
          obscureText: true,
          validator: (value) {
            return value == null || value.isEmpty
                ? 'Please enter your password'
                : null;
          },
          controller: passwordController,
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
            hintText: 'Password',
            prefixIcon: Icon(
              Icons.lock_rounded,
              color: context.theme.colorScheme.primary,
            ),
          ),
        ),
      ],
    );
  }
}
