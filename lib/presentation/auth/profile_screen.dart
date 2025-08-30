import 'package:flutter/material.dart';
import '../../data/services/auth_service.dart';
import '../../data/models/user.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _nameCtrl = TextEditingController();
  AppUserProfile? _profile;
  bool _loading = true;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    final auth = AuthService();
    try {
      // final p = await auth.getMyProfile();
      setState(() {
        // _profile = p;
        // _nameCtrl.text = p?.fullName ?? '';
        _loading = false;
      });
    } catch (e) {
      setState(() => _loading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No se pudo cargar tu perfil: $e')),
        );
      }
    }
  }

  String _initials(String? name, String? email) {
    final src = (name?.trim().isNotEmpty == true) ? name!.trim() : (email ?? 'U');
    final parts = src.split(RegExp(r'\s+'));
    final first = parts.isNotEmpty ? parts[0] : '';
    final second = parts.length > 1 ? parts[1] : '';
    final i1 = first.isNotEmpty ? first.characters.first.toUpperCase() : '';
    final i2 = second.isNotEmpty ? second.characters.first.toUpperCase() : '';
    final res = (i1 + i2).trim();
    return res.isEmpty ? 'U' : res;
  }

  Future<void> _save() async {
    final auth = AuthService();
    setState(() => _saving = true);
    try {
      // await auth.updateProfileName(_nameCtrl.text.trim());
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Perfil actualizado ✅')),
        );
      }
      await _load();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al guardar: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _logout() async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Cerrar sesión'),
        content: const Text('¿Deseas salir de tu cuenta?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancelar')),
          FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Salir')),
        ],
      ),
    );
    if (ok != true) return;

    final auth = AuthService();
    await auth.signOut();
    if (mounted) {
      Navigator.of(context).pushNamedAndRemoveUntil('/', (r) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil'),
        actions: [
          IconButton(
            tooltip: 'Cerrar sesión',
            onPressed: _logout,
            icon: const Icon(Icons.logout),
          )
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _profile == null
              ? const Center(child: Text('No se encontró tu perfil'))
              : ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    // Header con avatar redondo
                    Center(
                      child: Column(
                        children: [
                          Container(
                            width: 104, height: 104,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: scheme.primary, width: 3),
                              boxShadow: const [
                                BoxShadow(blurRadius: 10, spreadRadius: 1, offset: Offset(0, 4), color: Color(0x1A000000)),
                              ],
                            ),
                            clipBehavior: Clip.antiAlias,
                            child: Container(
                              color: const Color(0xFFEFF3FF),
                              child: Center(
                                child: Text(
                                  _initials(_profile!.fullName, _profile!.email),
                                  style: const TextStyle(fontSize: 34, fontWeight: FontWeight.w700),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Chip(
                            label: Text(
                              switch (_profile!.role) {
                                UserType.passenger => 'Pasajero',
                                UserType.driver => 'Chofer',
                                UserType.admin => 'Admin',
                              },
                            ),
                            avatar: const Icon(Icons.badge_outlined, size: 18),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Nombre (editable)
                    TextField(
                      controller: _nameCtrl,
                      decoration: const InputDecoration(
                        labelText: 'Nombre',
                        prefixIcon: Icon(Icons.person_outline),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Email (read-only si existe)
                    if ((_profile!.email ?? '').isNotEmpty) ...[
                      TextField(
                        controller: TextEditingController(text: _profile!.email!),
                        readOnly: true,
                        decoration: const InputDecoration(
                          labelText: 'Correo',
                          prefixIcon: Icon(Icons.email_outlined),
                        ),
                      ),
                      const SizedBox(height: 12),
                    ],

                    // Teléfono (read-only si existe)
                    if ((_profile!.phone ?? '').isNotEmpty) ...[
                      TextField(
                        controller: TextEditingController(text: _profile!.phone!),
                        readOnly: true,
                        decoration: const InputDecoration(
                          labelText: 'Celular',
                          prefixIcon: Icon(Icons.phone_outlined),
                        ),
                      ),
                      const SizedBox(height: 12),
                    ],

                    const SizedBox(height: 8),
                    FilledButton.icon(
                      onPressed: _saving ? null : _save,
                      icon: _saving
                          ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                          : const Icon(Icons.save_outlined),
                      label: const Text('Guardar cambios'),
                    ),

                    const SizedBox(height: 16),
                    OutlinedButton.icon(
                      onPressed: _logout,
                      icon: const Icon(Icons.logout),
                      label: const Text('Cerrar sesión'),
                    ),
                  ],
                ),
    );
  }
}
