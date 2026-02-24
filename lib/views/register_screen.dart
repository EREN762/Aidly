import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/auth_controller.dart';
import '../providers/auth_provider.dart';
import '../routes/app_routes.dart';
import 'login_screen.dart';
import 'widgets/app_spacing.dart';
import 'widgets/custom_button.dart';
import 'widgets/input_field.dart';
import 'widgets/view_transitions.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  bool _isLoading = false;

  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    try {
      final authProvider =
          Provider.of<AuthProvider>(context, listen: false);
      final controller = AuthController(authProvider);
      await controller.register(
        _emailController.text.trim(),
        _passwordController.text,
      );
      if (!mounted) return;
      Navigator.of(context).pushReplacementNamed(AppRoutes.home);
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur inscription: $error')),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _handleGoogle() async {
    setState(() => _isLoading = true);
    try {
      final authProvider =
          Provider.of<AuthProvider>(context, listen: false);
      final controller = AuthController(authProvider);
      await controller.signInWithGoogle();
      if (!mounted) return;
      Navigator.of(context).pushReplacementNamed(AppRoutes.home);
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur Google: $error')),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    theme.colorScheme.surface,
                    theme.colorScheme.surfaceContainerHighest,
                  ],
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                ),
              ),
            ),
          ),
          Positioned(
            top: -60,
            left: -40,
            child: _BentoBlob(color: theme.colorScheme.primary.withOpacity(0.14)),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: AppSpacing.screen,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  Text(
                    'Creer un compte',
                    style: theme.textTheme.displaySmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Rejoignez la communaute Aidly en quelques secondes.',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: const Color(0xFF5D6F69),
                    ),
                  ),
                  const SizedBox(height: 32),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Form(
                        key: _formKey,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        child: Column(
                          children: [
                            InputField(
                              label: 'Email',
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              prefixIcon: Icons.alternate_email,
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Email requis';
                                }
                                if (!value.contains('@')) {
                                  return 'Email invalide';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),
                            InputField(
                              label: 'Mot de passe',
                              controller: _passwordController,
                              obscureText: true,
                              prefixIcon: Icons.lock_outline,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Mot de passe requis';
                                }
                                if (value.length < 6) {
                                  return '6 caracteres minimum';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),
                            InputField(
                              label: 'Confirmer le mot de passe',
                              controller: _confirmController,
                              obscureText: true,
                              prefixIcon: Icons.lock_reset,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Confirmation requise';
                                }
                                if (value != _passwordController.text) {
                                  return 'Les mots de passe ne correspondent pas';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 20),
                            SizedBox(
                              width: double.infinity,
                              child: CustomButton(
                                label: 'Creer mon compte',
                                isLoading: _isLoading,
                                onPressed: _handleRegister,
                              ),
                            ),
                            const SizedBox(height: 12),
                            SizedBox(
                              width: double.infinity,
                              child: CustomButton(
                                label: 'Continuer avec Google',
                                icon: Icons.g_mobiledata,
                                variant: ButtonVariant.outline,
                                onPressed: _handleGoogle,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Deja un compte ?',
                        style: theme.textTheme.bodyMedium,
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pushReplacement(
                            sharedAxisRoute(page: const LoginScreen()),
                          );
                        },
                        child: const Text('Se connecter'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BentoBlob extends StatelessWidget {
  const _BentoBlob({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220,
      height: 220,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(48),
      ),
    );
  }
}
