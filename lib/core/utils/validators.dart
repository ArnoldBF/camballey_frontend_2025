class Validators {
  static String? requiredField(String? v) =>
      (v == null || v.trim().isEmpty) ? 'Obligatorio' : null;

  static String? minLength(String? v, int len) =>
      (v == null || v.length < len) ? 'Mínimo $len caracteres' : null;

  static bool looksLikeEmail(String v) => v.contains('@');

  static String normalizeBoPhone(String raw) {
    final digits = raw.replaceAll(RegExp(r'\D'), '');
    if (digits.startsWith('591')) return '+$digits';
    if (digits.length == 8) return '+591$digits';
    if (raw.startsWith('+')) return raw;
    return '+$digits';
  }
}