import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../widgets/custom_text_field.dart';
import 'package:proyecto_final/src/shared/utils.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginPage extends StatefulWidget 
{
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> 
{
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController(); 
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  void dispose()
  {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin()
  {
    if (_formKey.currentState!.validate()) {
        setState(() => _isLoading = true);

        // Simular login - aquí iría tu lógica de autenticación
        Future.delayed(const Duration(seconds: 2), () {
          setState(() => _isLoading = false);
          if (context.mounted) {
            Utils.showSnackBar(context: context, title: 'Bienvenido');
          }
        });
      }
  }

  Future<UserCredential?> _handleGoogleSignIn() async {
    // Trigger the authentication flow
    final GoogleSignIn signIn = GoogleSignIn.instance;

    await signIn.initialize();

    // Obtain the auth details from the request
    final GoogleSignInAccount googleAuth = await signIn.authenticate();

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      idToken: googleAuth.authentication.idToken,
    );

    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  @override
  Widget build(BuildContext context) 
  {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40.0),
        child: Form
        (
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 55),
              const Text('Bienvenido',
              style: TextStyle(
                fontSize: 30, 
                fontWeight: FontWeight.bold, 
                color: Color(0xFF1F2937))
              ),
              const SizedBox(height: 10),
              const Text(
                  'Inicia sesión en tu cuenta',
                  style: TextStyle(fontSize: 14, color: Color(0xFF6B7280)),
              ),
              const SizedBox(height: 5),
              CustomTextField(
                  label: 'Correo electrónico',
                  hint: 'ejemplo@gmail.com',
                  keyboardType: TextInputType.emailAddress,
                  controller: _emailController,
                  prefixIcon: Icons.email_outlined,
                  validator: (value) 
                  {
                    if (value == null || value.isEmpty) 
                    {
                      return 'Por favor ingresa tu correo';
                    }

                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Campo de contraseña
                CustomTextField(
                  label: 'Contraseña',
                  hint: '••••••••',
                  obscureText: true,
                  controller: _passwordController,
                  prefixIcon: Icons.lock_outlined,
                  suffixIcon: _obscurePassword
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                  onSuffixIconTap: () 
                  {
                    setState(() => _obscurePassword = !_obscurePassword);
                  },
                  validator: (value) 
                  {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingresa tu contraseña';
                    }
                    if (value.length < 6) {
                      return 'La contraseña debe tener al menos 6 caracteres';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),

                // Recordar contraseña / Olvidé contraseña
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {},
                    child: const Text(
                      '¿Olvidaste tu contraseña? Haz clic aquí',
                      style: TextStyle(
                        color: Color.fromARGB(255, 46, 106, 235),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Botón de inicio de sesión
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _handleLogin,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 46, 106, 235),
                      disabledBackgroundColor: const Color(0xFFD1D5DB),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation(Colors.white),
                              strokeWidth: 2,
                            ),
                          )
                        : const Text(
                            'Iniciar sesión',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 14),

                // Divisor
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 1,
                        color: const Color(0xFFE5E7EB),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      child: Text(
                        'O',
                        style: TextStyle(
                          color: Color(0xFF6B7280),
                          fontSize: 12,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        height: 1,
                        color: const Color(0xFFE5E7EB),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Botón de Google Sign-In
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: OutlinedButton(
                    onPressed: () async {
                      final user = await _handleGoogleSignIn();

                      if (user != null && context.mounted) {
                        context.push('/todos');
                      }
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(
                        color: Color(0xFFE5E7EB),
                        width: 1,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Image(image: AssetImage('assets/google.png')),
                        Image.asset('assets/google.png', width: 25, height: 25),
                        const SizedBox(width: 12),
                        const Text(
                          'Continuar con Google',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF1F2937),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Registrarse
                Center(
                  child: TextButton(
                    onPressed: () {
                      context.push('/register');
                    },
                    child: Text('¿No tienes cuenta? Registrate'),
                  ),
                ),
            ],
          )
        )
      ),
    )
    );
  }
}