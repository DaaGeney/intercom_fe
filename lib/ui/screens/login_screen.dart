import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../controllers/users_controller.dart';
import '../../theme/app_theme.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _usernameController = TextEditingController();
  bool _isLoading = false;
  bool _isValid = false;

  @override
  void initState() {
    super.initState();
    _usernameController.addListener(_validateUsername);
  }

  @override
  void dispose() {
    _usernameController.removeListener(_validateUsername);
    _usernameController.dispose();
    super.dispose();
  }

  void _validateUsername() {
    final text = _usernameController.text.trim();
    final isValid = text.length >= 3 && !text.contains(' ');
    if (_isValid != isValid) {
      setState(() {
        _isValid = isValid;
      });
    }
  }

  Future<void> _login() async {
    final username = _usernameController.text.trim();
    if (username.length < 3 || username.contains(' ')) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await ref.read(usersProvider.notifier).createUser(username);
      if (mounted) {
        context.go('/home');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: AppTheme.danger,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundDark,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 40),
              
              // Central Icon with waveform
              Center(
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppTheme.cardDark,
                      width: 3,
                    ),
                  ),
                  child: const Icon(
                    Icons.graphic_eq,
                    size: 60,
                    color: AppTheme.primaryBlue,
                  ),
                ),
              ),

              const SizedBox(height: 40),

              // Title
              const Text(
                '¡Hola!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppTheme.textPrimary,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 12),

              // Description
              Text(
                'Elige un nombre de usuario único para que tus amigos te reconozcan.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppTheme.textSecondary,
                  fontSize: 16,
                  height: 1.4,
                ),
              ),

              const SizedBox(height: 48),

              // Username Label
              const Text(
                'Nombre de usuario',
                style: TextStyle(
                  color: AppTheme.textPrimary,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),

              const SizedBox(height: 12),

              // Username Input Field
              TextField(
                controller: _usernameController,
                autofocus: true,
                style: const TextStyle(color: AppTheme.textPrimary, fontSize: 16),
                inputFormatters: [
                  FilteringTextInputFormatter.deny(RegExp(r'\s')), // No spaces
                ],
                onChanged: (_) => _validateUsername(),
                decoration: InputDecoration(
                  prefixText: '@',
                  prefixStyle: TextStyle(
                    color: AppTheme.textTertiary,
                    fontSize: 16,
                  ),
                  hintText: 'Ej. VoiceMaster99',
                  hintStyle: TextStyle(
                    color: AppTheme.textTertiary,
                    fontSize: 16,
                  ),
                  filled: true,
                  fillColor: AppTheme.cardDark,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(
                      color: _isValid ? AppTheme.primaryBlue : AppTheme.cardDark,
                      width: 2,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(
                      color: _isValid ? AppTheme.primaryBlue : AppTheme.cardDark,
                      width: 2,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: const BorderSide(
                      color: AppTheme.primaryBlue,
                      width: 2,
                    ),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 16,
                  ),
                ),
                onSubmitted: (_) => _isValid && !_isLoading ? _login() : null,
              ),

              const SizedBox(height: 8),

              // Hint
              Text(
                'Mínimo 3 caracteres, sin espacios.',
                style: TextStyle(
                  color: AppTheme.textTertiary,
                  fontSize: 12,
                ),
              ),

              const SizedBox(height: 48),

              // Enter Button
              SizedBox(
                height: 56,
                child: ElevatedButton(
                  onPressed: _isValid && !_isLoading ? _login : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryBlue,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: AppTheme.cardDark,
                    disabledForegroundColor: AppTheme.textTertiary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    elevation: 0,
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Entrar',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(width: 8),
                            Icon(Icons.arrow_forward, size: 20),
                          ],
                        ),
                ),
              ),

              const SizedBox(height: 60),

              // Terms and Privacy
              Padding(
                padding: const EdgeInsets.only(bottom: 32),
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: TextStyle(
                      color: AppTheme.textTertiary,
                      fontSize: 12,
                      height: 1.4,
                    ),
                    children: [
                      const TextSpan(text: 'Al continuar, aceptas nuestros '),
                      TextSpan(
                        text: 'Términos de Servicio',
                        style: const TextStyle(
                          color: AppTheme.primaryBlue,
                          fontWeight: FontWeight.w500,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            // TODO: Open terms
                          },
                      ),
                      const TextSpan(text: ' y '),
                      TextSpan(
                        text: 'Política de Privacidad',
                        style: const TextStyle(
                          color: AppTheme.primaryBlue,
                          fontWeight: FontWeight.w500,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            // TODO: Open privacy
                          },
                      ),
                      const TextSpan(text: '.'),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
