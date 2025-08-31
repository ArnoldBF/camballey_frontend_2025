import 'package:flutter/material.dart';
import '../../core/utils/validators.dart';
import '../../data/models/user.dart';
import '../../data/services/auth_service.dart';
import '../../routes/app_router.dart';
import '../../routes/app_router.dart' as r;

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
 final _formKey = GlobalKey<FormState>();

  final _nombreCtrl   = TextEditingController();
  final _apellidoCtrl = TextEditingController();
  final _ciCtrl       = TextEditingController();
  final _telCtrl      = TextEditingController();
  final _edadCtrl     = TextEditingController();
  final _correoCtrl   = TextEditingController();
  final _passCtrl     = TextEditingController();

  bool _loading = false;
  bool _obscure = true;
  final _auth = AuthService();
  final bool _autoLoginAfterRegister = true; // cambia a false si prefieres volver al login

  @override
  void dispose() {
    _correoCtrl.dispose();
    _telCtrl.dispose();
    _ciCtrl.dispose();
    _passCtrl.dispose();
    _nombreCtrl.dispose();
    _apellidoCtrl.dispose();
    _edadCtrl.dispose(); 
    super.dispose();
  }

  void _snack(String m) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(m)));


final _bgGradient = const LinearGradient(
    colors: [Color(0xFFF2F4FF), Color(0xFFF7F8FA)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  InputDecoration   _input(String label, IconData icon) => InputDecoration(
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


  Future<void> _submit() async {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) return;

    final edad = int.tryParse(_edadCtrl.text.trim());
    if (edad == null || edad <= 0) {
      _snack('Edad inválida');
      return;
    }

    setState(() => _loading = true);
    try {
      // 1) REGISTRO
      final data = await _auth.registerPassenger(
        nombre: _nombreCtrl.text.trim(),
        apellido: _apellidoCtrl.text.trim(),
        ci: _ciCtrl.text.trim(),
        telefono: _telCtrl.text.trim(),
        edad: edad,
        correo: _correoCtrl.text.trim(),
        password: _passCtrl.text,
      );

      final createdUserName = (data['userName'] as String?) ?? _correoCtrl.text.trim().split('@').first;
      debugPrint('[REGISTER] created userName=$createdUserName');

       // 2) Mensaje de éxito + redirección al login
    await _showSuccessAndGoLogin(createdUserName);
  } catch (e) {
    debugPrint('[REGISTER][UI ERROR] $e');
    _snack(e.toString().replaceFirst('Exception: ', ''));
  } finally {
    if (mounted) setState(() => _loading = false);
  }
  }


Future<void> _showSuccessAndGoLogin(String userName) async {
  await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text('Cuenta creada'),
      content: Text('El usuario "$userName" fue creado con éxito. Ahora puedes iniciar sesión.'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx, true),
          child: const Text('Ir al login'),
        ),
      ],
    ),
  );

  if (!mounted) return;
  debugPrint('[REGISTER] -> NAV: login');
  Navigator.of(context).pushNamedAndRemoveUntil(r.Routes.login, (_) => false);
}

  Future<void> _loginWithGoogle() async {
        setState(() => _loading = true);
        try {
          await _auth.loginWithGoogle();
          if (mounted) {
            Navigator.of(context).pushNamedAndRemoveUntil(r.Routes.login, (_) => false);
          }
        } catch (e) {
          _snack('Error autenticando con Google');
          debugPrint('[Google Auth Error] $e');
        } finally {
          if (mounted) setState(() => _loading = false);
        }
  }

  Future<void> _loginWithFacebook() async {
    // Aquí va la lógica de autenticación con Facebook
    _snack('Función Facebook aún no implementada');
  }


   @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: _bgGradient),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 560),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Container(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.95),
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: const [BoxShadow(color: Color(0x15000000), blurRadius: 24, offset: Offset(0, 12))],
                  ),
                  child: Column(
                    children: [
                      Text('¡Hola! Regístrate para empezar.',
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800)),
                      const SizedBox(height: 16),
                       Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              icon: Icon(Icons.g_mobiledata, color: Colors.red, size: 28),
                              label: const Text('Google'),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.black87,
                                side: const BorderSide(color: Color(0xFF2563EB)),
                                minimumSize: const Size(0, 48),
                                textStyle: const TextStyle(fontWeight: FontWeight.w600),
                              ),
                              onPressed: _loading ? null : _loginWithGoogle,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: OutlinedButton.icon(
                              icon: Icon(Icons.facebook, color: Color(0xFF2563EB), size: 28),
                              label: const Text('Facebook'),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Color(0xFF2563EB),
                                side: const BorderSide(color: Color(0xFF2563EB)),
                                minimumSize: const Size(0, 48),
                                textStyle: const TextStyle(fontWeight: FontWeight.w600),
                              ),
                              onPressed: _loading ? null : _loginWithFacebook,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),

                      Row(
                        children: [ 
                          Expanded(
                            child: TextFormField(
                              controller: _nombreCtrl,
                              decoration: _input('Nombre', Icons.badge_outlined),
                              validator: (v) => (v == null || v.isEmpty) ? 'Requerido' : null,
                              textCapitalization: TextCapitalization.words,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextFormField(
                              controller: _apellidoCtrl,
                              decoration: _input('Apellido', Icons.badge_outlined),
                              validator: (v) => (v == null || v.isEmpty) ? 'Requerido' : null,
                              textCapitalization: TextCapitalization.words,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      TextFormField(
                        controller: _ciCtrl,
                        decoration: _input('Carnet de Identidad', Icons.credit_card),
                        keyboardType: TextInputType.number,
                        validator: (v) => (v == null || v.isEmpty) ? 'Requerido' : null,
                      ),
                      const SizedBox(height: 12),

                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _telCtrl,
                              decoration: _input('Teléfono', Icons.phone),
                              keyboardType: TextInputType.phone,
                              validator: (v) => (v == null || v.isEmpty) ? 'Requerido' : null,
                            ),
                          ),
                          const SizedBox(width: 12),
                          SizedBox(
                            width: 160,
                            child: TextFormField(
                              controller: _edadCtrl,
                              decoration: _input('Edad', Icons.numbers),
                              keyboardType: TextInputType.number,
                              validator: (v) {
                                final n = int.tryParse((v ?? '').trim());
                                if (n == null || n <= 0) return 'Inválida';
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      TextFormField(
                        controller: _correoCtrl,
                        decoration: _input('Correo', Icons.email_outlined),
                        keyboardType: TextInputType.emailAddress,
                        validator: (v) =>
                            (v == null || v.isEmpty || !v.contains('@')) ? 'Correo inválido' : null,
                      ),
                      const SizedBox(height: 12),

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

                      const SizedBox(height: 18),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton(
                          onPressed: _loading ? null : _submit,
                          style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(52)),
                          child: _loading
                              ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
                              : const Text('Registrar'),
                        ),
                      ),
                      const SizedBox(height: 12),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('¿Ya tienes una cuenta?'),
                          TextButton(
                            onPressed: () => Navigator.pushNamedAndRemoveUntil(context, r.Routes.login, (r) => false),
                            child: const Text(' Inicia sesión Ahora'),
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


