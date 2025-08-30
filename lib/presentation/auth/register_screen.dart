import 'package:flutter/material.dart';
import '../../core/utils/validators.dart';
import '../../data/models/user.dart';
import '../../data/services/auth_service.dart';
import '../../routes/app_router.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  final _emailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _ciCtrl    = TextEditingController();
  final _passCtrl  = TextEditingController();
  final _nameCtrl  = TextEditingController();

  final _otpCtrl   = TextEditingController();

  final _auth = AuthService();

  bool _loading = false;
  bool _waitingOtp = false; // paso 2
  UserType _role = UserType.passenger;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _ciCtrl.dispose();
    _passCtrl.dispose();
    _nameCtrl.dispose();
    _otpCtrl.dispose();
    super.dispose();
  }

  void _snack(String m) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(m)));

  Future<void> _startRegister() async {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) return;

    final email = _emailCtrl.text.trim();
    final phone = _phoneCtrl.text.trim();
    final pass  = _passCtrl.text;

    if (email.isEmpty && phone.isEmpty) {
      _snack('Ingresa al menos correo o teléfono');
      return;
    }

    setState(() => _loading = true);
    try {
      // 1) Si hay correo, crea cuenta por email+password
      if (email.isNotEmpty) {
        // await _auth.signUpWithEmailPassword(email: email, password: pass);
      }

      // 2) Si hay teléfono, envía OTP para terminar registro
      if (phone.isNotEmpty) {
        // await _auth.signUpWithPhone(phone);
        if (!mounted) return;
        setState(() => _waitingOtp = true); // paso 2
        _snack('Te enviamos un código por SMS');
        return; // esperamos confirmación OTP para crear perfil
      }

      // 3) Si solo fue email, ya podemos crear perfil y mandar a login
      // await _auth.upsertProfile(role: _role.value, fullName: _nameCtrl.text.trim());
      if (mounted) {
        _snack('Cuenta creada. Revisa tu correo si requiere verificación.');
        Navigator.of(context).pushNamedAndRemoveUntil(Routes.login, (r) => false);
      }
    } catch (e) {
      _snack('No se pudo registrar: $e');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _finishRegisterWithOtp() async {
    final code = _otpCtrl.text.trim();
    if (code.length < 4) {
      _snack('Ingresa el código SMS');
      return;
    }
    setState(() => _loading = true);
    try {
      // await _auth.confirmPhoneSignup(phone: _phoneCtrl.text.trim(), code: code);
      // await _auth.upsertProfile(role: _role.value, fullName: _nameCtrl.text.trim());
      if (mounted) {
        _snack('Registro completado ✅');
        Navigator.of(context).pushNamedAndRemoveUntil(Routes.login, (r) => false);
      }
    } catch (e) {
      _snack('Código inválido: $e');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(
            _waitingOtp ? 'Te enviamos un Código de Registro!' : '¡Hola! Regístrate para empezar.',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 18),
          if (!_waitingOtp) _formStep(context) else _otpStep(context),
        ],
      ),
    );
  }

  Widget _formStep(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          const SizedBox(height: 6),
          TextFormField(
            controller: _emailCtrl,
            decoration: const InputDecoration(
              labelText: 'Correo Electrónico',
              filled: true,
            ),
            keyboardType: TextInputType.emailAddress,
            validator: (v) {
              if ((v ?? '').isEmpty && _phoneCtrl.text.trim().isEmpty) return 'Ingresa correo o teléfono';
              if ((v ?? '').isNotEmpty && !Validators.looksLikeEmail(v!)) return 'Correo inválido';
              return null;
            },
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _phoneCtrl,
            decoration: const InputDecoration(labelText: 'Teléfono', filled: true),
            keyboardType: TextInputType.phone,
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _ciCtrl,
            decoration: const InputDecoration(labelText: 'Carnet de Identidad', filled: true),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _nameCtrl,
            decoration: const InputDecoration(labelText: 'Nombre completo', filled: true),
            textCapitalization: TextCapitalization.words,
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _passCtrl,
            decoration: const InputDecoration(labelText: 'Contraseña', filled: true),
            obscureText: true,
            validator: (v) {
              if ((_emailCtrl.text.trim().isNotEmpty) && (v == null || v.length < 6)) {
                return 'Mínimo 6 caracteres';
              }
              return null;
            },
          ),
          const SizedBox(height: 12),
          // DropdownButtonFormField<UserType>(
          //   value: _role,
          //   decoration: const InputDecoration(labelText: 'Tipo de usuario', filled: true),
          //   items: UserType.values
          //       .map((t) => DropdownMenuItem(value: t, child: Text(t.label)))
          //       .toList(),
          //   onChanged: (v) => setState(() => _role = v ?? UserType.passenger),
          // ),
          const SizedBox(height: 18),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: _loading ? null : _startRegister,
              child: _loading
                  ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
                  : const Text('Register'),
            ),
          ),
          const SizedBox(height: 18),
          _socialRow(disabled: true),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Ya tienes una cuenta?  '),
              TextButton(
                onPressed: () => Navigator.pushNamedAndRemoveUntil(context, Routes.login, (r) => false),
                child: const Text('Inicia sesión Ahora'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _otpStep(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 12),
        TextField(
          controller: _phoneCtrl,
          readOnly: true,
          decoration: const InputDecoration(labelText: 'Usuario (teléfono)', filled: true),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _otpCtrl,
          decoration: const InputDecoration(labelText: 'Código de Registro', filled: true),
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 18),
        SizedBox(
          width: double.infinity,
          child: FilledButton(
            onPressed: _loading ? null : _finishRegisterWithOtp,
            child: _loading
                ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
                : const Text('Terminar Registro'),
          ),
        ),
        const SizedBox(height: 18),
        _socialRow(disabled: true),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('¿No tienes una cuenta?  '),
            TextButton(
              onPressed: () => setState(() => _waitingOtp = false),
              child: const Text('Registrarme Ahora'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _socialRow({bool disabled = false}) {
    final widgets = [
      _socialBtn(Icons.facebook, onTap: disabled ? null : () {}),
      _socialBtn(Icons.g_mobiledata, onTap: disabled ? null : () {}),
      _socialBtn(Icons.apple, onTap: disabled ? null : () {}),
    ];
    return Column(
      children: [
        Row(children: const [
          Expanded(child: Divider()), SizedBox(width: 8),
          Text('  O Registrar Con  '),
          SizedBox(width: 8), Expanded(child: Divider()),
        ]),
        const SizedBox(height: 12),
        Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: widgets),
      ],
    );
  }

  Widget _socialBtn(IconData icon, {VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 64, height: 48,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [BoxShadow(color: Color(0x11000000), blurRadius: 8, offset: Offset(0, 4))],
        ),
        child: Icon(icon, size: 28),
      ),
    );
  }
}
