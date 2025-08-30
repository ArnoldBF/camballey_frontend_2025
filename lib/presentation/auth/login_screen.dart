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

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _userCtrl = TextEditingController();
  //  final _passCtrl = TextEditingController();
  final _nameCtrl = TextEditingController();
  final _smsCtrl  = TextEditingController();

  final _emailCtrl = TextEditingController(text: 'monrodrigot@gmail.com');
  final _passCtrl = TextEditingController(text: '12345678');
  final List<String> _roles = const ['Chofer', 'Pasajero'];
  String _selectedRole = 'Chofer';
  
  final _auth = AuthService();
  bool _waitingSms = false;
  bool _loading = false;
  UserType _role = UserType.passenger;

  @override
  void dispose() {
   // _userCtrl.dispose(); _passCtrl.dispose(); _nameCtrl.dispose(); _smsCtrl.dispose();
   _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }
  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    // Navega por rol
    final route =
        (_selectedRole == 'Chofer') ? r.Routes.driver : r.Routes.passenger;
    Navigator.of(context).pushReplacementNamed(route);
  }
  void _snack(String m) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(m)));
  bool get _isEmail => Validators.looksLikeEmail(_userCtrl.text);

  Future<void> _startLogin() async {
  final isValid = _formKey.currentState?.validate() ?? false;
  if (!isValid) return;

  setState(() => _loading = true);
  try {
    if (_isEmail) {
      await _auth.signInWithEmail(_userCtrl.text, _passCtrl.text);
      await _postLogin();
    } else {
      await _auth.startPhoneOtp(_userCtrl.text);
      if (!mounted) return;
      setState(() => _waitingSms = true);
      _snack('Te enviamos un SMS con el código');
    }
  } on AuthException catch (e) {
    _snack(e.message);
  } catch (e) {
    _snack('Error: $e');
  } finally {
    if (mounted) setState(() => _loading = false);
  }
}

  Future<void> _confirmOtp() async {
    if (_smsCtrl.text.trim().length < 4) return _snack('Ingresa el código SMS');
    setState(() => _loading = true);
    try {
      await _auth.verifySmsCode(_userCtrl.text, _smsCtrl.text);
      await _postLogin();
    } on AuthException catch (e) {
      _snack(e.message);
    } finally {
      setState(() => _loading = false);
    }
  }

  Future<void> _postLogin() async {
    await _auth.upsertProfile(
      role: _role.value,
      fullName: _nameCtrl.text.trim(),
    );
    if (mounted) Navigator.pushReplacementNamed(context, '/home');
  }

  /*@override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: _waitingSms ? _otpStep() : _loginStep(),
            ),
          ),
        ),
      ),
    );
  }*/
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FA),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Form(
              key: _formKey,
              child: ListView(
                shrinkWrap: true,
                children: [
                  const SizedBox(height: 80),
                  const Text('Iniciar sesión',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 32, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 28),

                  // Email
                  TextFormField(
                    controller: _emailCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Correo o celular',
                      prefixIcon: Icon(Icons.person),
                    ),
                    validator: (v) =>
                        (v == null || v.isEmpty) ? 'Requerido' : null,
                  ),
                  const SizedBox(height: 16),

                  // Password
                  TextFormField(
                    controller: _passCtrl,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Contraseña',
                      prefixIcon: Icon(Icons.lock),
                    ),
                    validator: (v) =>
                        (v == null || v.length < 6) ? 'Mínimo 6 caracteres' : null,
                  ),
                  const SizedBox(height: 16),

                  // Rol
                  DropdownButtonFormField<String>(
                    value: _selectedRole,
                    decoration: const InputDecoration(
                      labelText: 'Tipo de usuario',
                      prefixIcon: Icon(Icons.person_outline),
                    ),
                    items: _roles
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                    onChanged: (v) => setState(() => _selectedRole = v ?? 'Chofer'),
                  ),
                  const SizedBox(height: 28),

                  // Botón
                  SizedBox(
                    height: 52,
                    child: ElevatedButton(
                      onPressed: _submit,
                      child: const Text('Entrar'),
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }


  Widget _loginStep() {
    return Form(
      key: _formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        const SizedBox(height: 24),
        Text('Iniciar sesión', style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(height: 16),

        TextFormField(
          controller: _userCtrl,
          decoration: const InputDecoration(
            labelText: 'Correo o celular',
            hintText: 'ejemplo@correo.com o 7XXXXXXX',
            prefixIcon: Icon(Icons.person),
          ),
          keyboardType: TextInputType.emailAddress,
          validator: Validators.requiredField,
          onChanged: (_) => setState((){}),
        ),
        const SizedBox(height: 12),

        // if (_isEmail)
          TextFormField(
            controller: _passCtrl,
            obscureText: true,
            decoration: const InputDecoration(
              labelText: 'Contraseña',
              prefixIcon: Icon(Icons.lock),
            ),
            validator: (v) => _isEmail ? Validators.minLength(v, 6) : null,
          ),

        const SizedBox(height: 12),
        // TextFormField(
        //   controller: _nameCtrl,
        //   decoration: const InputDecoration(
        //     labelText: 'Nombre (para perfil)',
        //     prefixIcon: Icon(Icons.badge_outlined),
        //   ),
        // ),
        // const SizedBox(height: 12),

        DropdownButtonFormField<UserType>(
          value: _role,
          items: UserType.values
              .map((t) => DropdownMenuItem(value: t, child: Text(t.label)))
              .toList(),
          onChanged: (v) => setState(() => _role = v ?? UserType.passenger),
          decoration: const InputDecoration(
            labelText: 'Tipo de usuario',
            prefixIcon: Icon(Icons.person_outline),
          ),
        ),

        const SizedBox(height: 20),
        SizedBox(
          width: double.infinity,
          child: FilledButton(
            onPressed: _loading ? null : _startLogin,
            child: _loading
                ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
                : Text(_isEmail ? 'Entrar' : 'Enviar código SMS'),
          ),
        ),
      ]),
    );
  }

  Widget _otpStep() {
    return Column(mainAxisSize: MainAxisSize.min, children: [
      const SizedBox(height: 24),
      Text('Verificación por SMS', style: Theme.of(context).textTheme.headlineMedium),
      const SizedBox(height: 8),
      const Text('Ingresa el código que te enviamos'),
      const SizedBox(height: 12),
      TextField(
        controller: _smsCtrl,
        keyboardType: TextInputType.number,
        decoration: const InputDecoration(
          labelText: 'Código SMS',
          prefixIcon: Icon(Icons.sms),
        ),
      ),
      const SizedBox(height: 20),
      SizedBox(
        width: double.infinity,
        child: FilledButton(
          onPressed: _loading ? null : _confirmOtp,
          child: _loading
              ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
              : const Text('Confirmar'),
        ),
      ),
      TextButton(
        onPressed: _loading ? null : () => setState(() => _waitingSms = false),
        child: const Text('Volver'),
      ),
    ]);
  }
}
