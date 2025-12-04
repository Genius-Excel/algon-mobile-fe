import 'package:algon_mobile/core/enums/user_role.dart';
import 'package:algon_mobile/core/service_exceptions/api_exceptions.dart';
import 'package:algon_mobile/features/auth/data/models/register_models.dart';
import 'package:algon_mobile/features/auth/data/repository/auth_repository_impl.dart';
import 'package:algon_mobile/shared/widgets/custom_button.dart';
import 'package:algon_mobile/shared/widgets/custom_dropdown_field.dart';
import 'package:algon_mobile/shared/widgets/custom_text_field.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:algon_mobile/src/constants/app_colors.dart';
import 'package:algon_mobile/shared/widgets/toast.dart';

@RoutePage(name: 'SignUp')
class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key});

  @override
  ConsumerState<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _ninController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  UserRole? _selectedRole;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;

  // Available roles for signup (based on API docs)
  final List<UserRole> _availableRoles = [
    UserRole.applicant,
    UserRole.superAdmin,
    UserRole.immigrationOfficer,
    UserRole.lgAdmin,
  ];

  @override
  void dispose() {
    _ninController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleSignUp() async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    if (_selectedRole == null) {
      Toast.error('Please select a role', context);
      return;
    }

    // Set loading state and wait for next frame to ensure UI updates
    setState(() {
      _isLoading = true;
    });

    // Ensure the UI has a chance to update
    await Future.delayed(const Duration(milliseconds: 50));

    try {
      print('📝 Starting signup process...');
      print('   Role: ${_selectedRole?.label}');
      print('   Email: ${_emailController.text.trim()}');
      print('   Phone: ${_phoneController.text.trim()}');

      final authRepository = ref.read(authRepositoryProvider);
      print('✅ Auth repository obtained');

      final request = RegisterRequest(
        email: _emailController.text.trim(),
        phoneNumber: _phoneController.text.trim(),
        password: _passwordController.text,
        nin: _ninController.text.trim().isNotEmpty
            ? _ninController.text.trim()
            : null,
      );

      final apiRole = _selectedRole!.toApiRole();
      print('🚀 Calling register API with role: $apiRole');

      final result = await authRepository.register(request, apiRole);
      print('📥 Register API call completed');

      result.when(
        success: (RegisterResponse response) {
          if (mounted) {
            Toast.success(response.message, context);
            // Navigate to login after successful registration
            Future.delayed(const Duration(seconds: 2), () {
              if (mounted) {
                context.router.pushNamed('/login');
              }
            });
          }
        },
        apiFailure: (error, statusCode) {
          if (mounted) {
            if (error is ApiExceptions) {
              Toast.apiError(error, context);
            } else {
              Toast.error(error.toString(), context);
            }
          }
        },
      );
    } catch (e, stackTrace) {
      print('❌ Signup Error Caught:');
      print('   Error: $e');
      print('   Error Type: ${e.runtimeType}');
      print('   StackTrace: $stackTrace');

      if (mounted) {
        Toast.error('An unexpected error occurred: ${e.toString()}', context);
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  bool _isValidPassword(String password) {
    final hasUpper = password.contains(RegExp(r'[A-Z]'));
    final hasLower = password.contains(RegExp(r'[a-z]'));
    final hasDigit = password.contains(RegExp(r'[0-9]'));
    final hasSpecial = password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
    return hasUpper &&
        hasLower &&
        hasDigit &&
        hasSpecial &&
        password.length >= 8;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: AppColors.primaryGradient,
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => context.router.maybePop(),
              ),
            ),
          ),
          Column(
            children: [
              const SafeArea(
                child: Padding(
                  padding: EdgeInsets.only(top: 80, bottom: 32),
                  child: Column(
                    children: [
                      Text(
                        'Create Account',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Join us to get started',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
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
                          label: 'Sign up as',
                          value: _selectedRole ?? _availableRoles.first,
                          items: _availableRoles,
                          itemBuilder: (role) => role.label,
                          onChanged: (value) {
                            setState(() {
                              _selectedRole = value;
                            });
                          },
                        ),
                        const SizedBox(height: 16),
                        CustomTextField(
                          controller: _ninController,
                          label: 'National Identity Number (NIN)',
                          hint: 'Enter your NIN',
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            // NIN is optional for super-admin, required for applicant
                            if (_selectedRole == UserRole.applicant &&
                                (value == null || value.isEmpty)) {
                              return 'NIN is required for applicants';
                            }
                            if (value != null &&
                                value.isNotEmpty &&
                                value.length != 11) {
                              return 'NIN must be 11 digits';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        CustomTextField(
                          controller: _emailController,
                          label: 'Email Address',
                          hint: 'Enter your email',
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your email';
                            }
                            if (!value.contains('@')) {
                              return 'Please enter a valid email';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        CustomTextField(
                          controller: _phoneController,
                          label: 'Phone Number',
                          hint: 'Enter your phone number (11 digits)',
                          keyboardType: TextInputType.phone,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your phone number';
                            }
                            if (value.length != 11) {
                              return 'Phone number must be 11 digits';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        CustomTextField(
                          controller: _passwordController,
                          label: 'Password',
                          hint: 'Create a password',
                          obscureText: _obscurePassword,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a password';
                            }
                            if (!_isValidPassword(value)) {
                              return 'Password must be at least 8 characters and include uppercase, lowercase, numbers, and special characters';
                            }
                            return null;
                          },
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
                        const SizedBox(height: 16),
                        CustomTextField(
                          controller: _confirmPasswordController,
                          label: 'Confirm Password',
                          hint: 'Confirm your password',
                          obscureText: _obscureConfirmPassword,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please confirm your password';
                            }
                            if (value != _passwordController.text) {
                              return 'Passwords do not match';
                            }
                            return null;
                          },
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscureConfirmPassword
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscureConfirmPassword =
                                    !_obscureConfirmPassword;
                              });
                            },
                          ),
                        ),
                        const SizedBox(height: 32),
                        CustomButton(
                          text: 'Create Account',
                          isLoading: _isLoading,
                          onPressed: _handleSignUp,
                          isFullWidth: true,
                        ),
                        const SizedBox(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Already have an account? ",
                              style: TextStyle(
                                color: Color(0xFF6B7280),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                context.router.pushNamed('/login');
                              },
                              child: const Text(
                                'Login',
                                style: TextStyle(
                                  color: AppColors.green,
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
        ],
      ),
    );
  }
}
