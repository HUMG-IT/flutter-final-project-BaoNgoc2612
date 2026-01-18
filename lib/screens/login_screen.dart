import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import 'forgot_password_screen.dart';
import '../theme/app_theme.dart';
import '../providers/language_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  String? _error;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header with Gradient
            Container(
              height: 300,
              decoration: const BoxDecoration(
                gradient: AppTheme.primaryGradient,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(60),
                  bottomRight: Radius.circular(60),
                ),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.people_alt_rounded,
                            size: 80,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Consumer<LanguageProvider>(
                          builder: (context, lang, _) => Text(
                            lang.getText('app_title'),
                            style: Theme.of(context).textTheme.displayMedium?.copyWith(
                                  color: Colors.white,
                                ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Consumer<LanguageProvider>(
                          builder: (context, lang, _) => Text(
                            lang.getText('welcome_back'),
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                  color: Colors.white70,
                                ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: 40,
                    right: 20,
                    child: Consumer<LanguageProvider>(
                      builder: (context, lang, _) => Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: DropdownButton<String>(
                          value: lang.currentLanguage,
                          dropdownColor: AppTheme.primaryColor,
                          icon: const Icon(Icons.language, color: Colors.white),
                          underline: const SizedBox(),
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                          items: const [
                            DropdownMenuItem(value: 'en', child: Text('English')),
                            DropdownMenuItem(value: 'vi', child: Text('Tiếng Việt')),
                          ],
                          onChanged: (value) async {
                            if (value != null) {
                              await lang.setLanguage(value);
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 40),

            // Login Form
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Consumer<LanguageProvider>(
                    builder: (context, lang, _) => Text(
                      lang.getText('login_title'),
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppTheme.primaryColor,
                          ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  Consumer<LanguageProvider>(
                    builder: (context, lang, _) => TextField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: lang.getText('email'),
                        prefixIcon: const Icon(Icons.email_outlined),
                      ),
                      keyboardType: TextInputType.emailAddress,
                    ),
                  ),
                  const SizedBox(height: 16),

                  Consumer<LanguageProvider>(
                    builder: (context, lang, _) => TextField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                        labelText: lang.getText('password'),
                        prefixIcon: const Icon(Icons.lock_outline),
                      ),
                      obscureText: true,
                    ),
                  ),
                  
                  const SizedBox(height: 12),
                  
                  // Forgot Password
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const ForgotPasswordScreen(),
                          ),
                        );
                      },
                      child: Consumer<LanguageProvider>(
                        builder: (context, lang, _) => Text(
                          lang.getText('forgot_password'),
                          style: TextStyle(
                            color: AppTheme.primaryColor.withValues(alpha: 0.8),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  if (_error != null)
                    Container(
                      padding: const EdgeInsets.all(12),
                      margin: const EdgeInsets.only(bottom: 20),
                      decoration: BoxDecoration(
                        color: Colors.red.shade50,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.red.shade200),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.error_outline, color: Colors.red.shade700),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              _error!,
                              style: TextStyle(color: Colors.red.shade700),
                            ),
                          ),
                        ],
                      ),
                    ),

                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _login,
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 4,
                        shadowColor: AppTheme.primaryColor.withValues(alpha: 0.4),
                      ),
                      child: _isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : Consumer<LanguageProvider>(
                                builder: (context, lang, _) => Text(
                                  lang.getText('login_btn'),
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1.2,
                                  ),
                                ),
                              ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Consumer<LanguageProvider>(
                        builder: (context, lang, _) => Text(
                          '${lang.getText('dont_have_account')} ',
                          style: TextStyle(color: Colors.grey.shade600),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.pushNamed(context, '/register'),
                        child: Consumer<LanguageProvider>(
                          builder: (context, lang, _) => Text(
                            lang.getText('register_btn'),
                            style: const TextStyle(
                              color: AppTheme.secondaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _login() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      setState(() => _error = 'Please enter both email and password');
      return;
    }

    setState(() => _isLoading = true);
    try {
      await context.read<AuthProvider>().login(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );
      if (mounted) {
        setState(() => _isLoading = false);
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        
        final errorMessage = e.toString();
        if (errorMessage.contains('Email chưa được xác thực')) {
          _showVerificationDialog();
        } else {
          setState(() {
            _error = errorMessage.replaceAll('Exception: ', '');
          });
        }
      }
    }
  }

  void _showVerificationDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: const [
            Icon(Icons.mark_email_unread, color: Colors.orange),
            SizedBox(width: 8),
            Text('Email Not Verified'),
          ],
        ),
        content: const Text(
          'Your email is not verified yet. Please check your inbox and verify your email to login.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _resendVerification();
            },
            child: const Text('Resend Email'),
          ),
        ],
      ),
    );
  }

  Future<void> _resendVerification() async {
    setState(() => _isLoading = true);
    try {
      await context.read<AuthProvider>().resendVerificationEmail(
        _emailController.text.trim(),
        _passwordController.text,
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Verification email sent! Please check your inbox.'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() => _error = e.toString().replaceAll('Exception: ', ''));
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }
}
