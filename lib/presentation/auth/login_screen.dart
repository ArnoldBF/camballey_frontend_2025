import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../core/utils/validators.dart';
import '../../data/models/user.dart';
import '../../data/services/auth_service.dart';
import '../../routes/app_router.dart' as r; // alias para Routes

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}


/* ---------- Botón gradiente ---------- */
class _GradientButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed; // <- permite deshabilitar
  const _GradientButton({required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF6D5DF6), Color(0xFF8A7CFF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.all(Radius.circular(24)),
        boxShadow: [
          BoxShadow(color: Color(0x33000000), blurRadius: 16, offset: Offset(0, 8)),
        ],
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          minimumSize: const Size.fromHeight(56),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        ),
        child: Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
      ),
    );
  }
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  final _emailCtrl = TextEditingController(text: 'angelo.montalvo');
  final _passCtrl = TextEditingController(text: 'MiPassword123');
  
  bool _loading = false;
  bool _obscure = true;

  @override
  void dispose() {
   _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  /* ---------- Login ---------- */
  Future<void> _submit() async {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) return;

    final userName = _emailCtrl.text.trim();
    final password = _passCtrl.text;

    // LOGS (solo para desarrollo)
    debugPrint('[LOGIN] endpoint: /auth/login');
    debugPrint('[LOGIN] userName="$userName" password.length=${password.length}');

    setState(() => _loading = true);
    try {
      final auth = AuthService();
      final role = await auth.signInUsernamePassword(
        userName: userName,
        password: password,
      );

      debugPrint('[LOGIN] role from token: $role');

      if (!mounted) return;
      if (role == 3) {
        debugPrint('[NAV] -> Routes.driver');
        Navigator.of(context).pushNamedAndRemoveUntil(r.Routes.driver, (_) => false);
      } else {
        debugPrint('[NAV] -> Routes.passenger');
        Navigator.of(context).pushNamedAndRemoveUntil(r.Routes.passenger, (_) => false);
      }
    } catch (e) {
      debugPrint('[LOGIN][ERROR] $e');
      _snack(e.toString().replaceFirst('Exception: ', ''));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _snack(String m) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(m)));



   // --- LOGO helper ---
  Widget _buildLogo() {
  final primary = Theme.of(context).colorScheme.primary;
  return Padding(
    padding: const EdgeInsets.only(top: 8, bottom: 16),
    child: Hero(
      tag: 'app_logo',
      child: Container(
        width: 120,
        height: 120,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: const LinearGradient(
            colors:  [Color(0xFF6D5DF6), Color(0xFF8A7CFF)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight, 
            ),
          // border: Border.all(color: primary, width: 3),
          boxShadow: const [
            BoxShadow(
              blurRadius: 16,
              offset: Offset(0, 8),
              color: Color(0x22000000), // sombra sutil
            ),
          ],
        ),
        // clipBehavior: Clip.antiAlias, // recorta el contenido al círculo
        child: Center(
          child: Container(
            width: 110,
            height: 110,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(color: primary.withOpacity(0.12), width: 1),
              ),
              clipBehavior: Clip.antiAlias,
              child: Image.asset(
                'assets/images/logo.png',
                fit: BoxFit.contain, // ajusta dentro del círculo
                errorBuilder: (_, __, ___) =>
                    const Icon(Icons.directions_bus, size: 72, color: Colors.grey
            ),
            
          ),
        ),
      ),
      ),
    )
  );
}


final _bgGradient = const LinearGradient(
  colors: [Color(0xFFF2F4FF), Color(0xFFF7F8FA)],
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
);

InputDecoration _input(String label, IconData icon) => InputDecoration(
  labelText: label,
  prefixIcon: Icon(icon),
  filled: true,
  fillColor: Colors.white,
  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(14),
    borderSide: const BorderSide(color: Color(0x11000000)),
  ),
  enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(14),
    borderSide: const BorderSide(color: Color(0x11000000)),
  ),
  focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(14),
    borderSide: BorderSide(color: Theme.of(context).colorScheme.primary, width: 1.5),
  ),
);



 @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: _bgGradient),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              child: Form(
                key: _formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Container(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: const [
                      BoxShadow(color: Color(0x15000000), blurRadius: 24, offset: Offset(0, 12)),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildLogo(),
                      const SizedBox(height: 4),
                      Text(
                        'Iniciar sesión',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF222222),
                            ),
                      ),
                      const SizedBox(height: 22),

                      TextFormField(
                        controller: _emailCtrl,
                        decoration: _input('Usuario o correo', Icons.person),
                        validator: (v) => (v == null || v.isEmpty) ? 'Requerido' : null,
                      ),
                      const SizedBox(height: 14),

                      TextFormField(
                        controller: _passCtrl,
                        obscureText: _obscure,
                        decoration: _input('Contraseña', Icons.lock).copyWith(
                          suffixIcon: IconButton(
                            onPressed: () => setState(() => _obscure = !_obscure),
                            icon: Icon(_obscure ? Icons.visibility_off : Icons.visibility),
                          ),
                        ),
                        validator: (v) => (v == null || v.length < 6) ? 'Mínimo 6 caracteres' : null,
                      ),

                      const SizedBox(height: 22),

                      // Deshabilita mientras carga
                      _GradientButton(
                        label: _loading ? 'Ingresando...' : 'Entrar',
                        onPressed: _loading ? null : _submit,
                      ),

                      const SizedBox(height: 14),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('¿No tienes cuenta?'),
                          TextButton(
                            onPressed: () => Navigator.pushNamed(context, r.Routes.register),
                            child: const Text(' Registrarme Ahora'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
