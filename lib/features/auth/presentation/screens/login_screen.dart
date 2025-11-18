import 'package:algon_mobile/core/enums/user_role.dart';
import 'package:algon_mobile/shared/widgets/custom_button.dart';
import 'package:algon_mobile/shared/widgets/margin.dart';
import 'package:algon_mobile/src/constants/app_colors.dart';
import 'package:algon_mobile/src/res/styles.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:algon_mobile/shared/widgets/custom_text_field.dart';
import 'package:algon_mobile/shared/widgets/custom_dropdown_field.dart';

@RoutePage(name: 'Login')
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailOrNinController = TextEditingController();
  final _passwordController = TextEditingController();
  UserRole? _selectedLoginType;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailOrNinController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration:
                const BoxDecoration(gradient: AppColors.primaryGradient),
          ),
          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 40),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Image.asset(
                    'assets/images/nigeria-flag.png',
                    height: 50,
                    width: 100,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Welcome Back',
                  style: AppStyles.textStyle.copyWith(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Sign in to continue',
                  style: AppStyles.textStyle.copyWith(
                    fontSize: 16,
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 32),
                Expanded(
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(30),
                      ),
                    ),
                    padding: const EdgeInsets.all(24),
                    child: Form(
                      key: _formKey,
                      child: ListView(
                        children: [
                          CustomDropdownField<UserRole>(
                            label: 'Login As',
                            value: _selectedLoginType ?? UserRole.applicant,
                            items: UserRole.values,
                            itemBuilder: (role) => role.label,
                            onChanged: (value) {
                              setState(() {
                                _selectedLoginType = value;
                              });
                            },
                          ),
                          const SizedBox(height: 16),
                          CustomTextField(
                            controller: _emailOrNinController,
                            label: 'Email or NIN',
                            hint: 'Enter your email or NIN',
                          ),
                          const SizedBox(height: 16),
                          CustomTextField(
                            controller: _passwordController,
                            label: 'Password',
                            hint: 'Enter your password',
                            obscureText: _obscurePassword,
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePassword
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscurePassword = !_obscurePassword;
                                });
                              },
                            ),
                          ),
                          const SizedBox(height: 8),
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () {},
                              child: const Text(
                                'Forgot Password?',
                                style: TextStyle(
                                  color: Color(0xFF0D9488),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                          const ColSpacing(32),
                          CustomButton(
                            text: 'Login',
                            onPressed: () async {
                              if (_formKey.currentState?.validate() ?? false) {
                                final role =
                                    _selectedLoginType ?? UserRole.applicant;
                                if (role == UserRole.superAdmin) {
                                  context.router
                                      .pushNamed('/super-admin/dashboard');
                                } else if (role == UserRole.lgAdmin) {
                                  context.router.pushNamed('/admin/dashboard');
                                } else if (role == UserRole.immigrationOfficer) {
                                  // Store role in shared preferences for verify screen
                                  final prefs = await SharedPreferences.getInstance();
                                  await prefs.setString('user_role', role.name);
                                  context.router.pushNamed('/verify/certificate');
                                } else {
                                  context.router.pushNamed('/home');
                                }
                              }
                            },
                          ),
                          const ColSpacing(16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "Don't have an account? ",
                                style: TextStyle(
                                  color: Color(0xFF6B7280),
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  context.router.pushNamed('/signup');
                                },
                                child: const Text(
                                  'Sign Up',
                                  style: TextStyle(
                                    color: Color(0xFF0D9488),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
