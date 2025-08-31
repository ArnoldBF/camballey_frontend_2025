import 'package:flutter/material.dart';
import 'confirm_pago_view.dart';

class MultiPagosPage extends StatefulWidget {
  const MultiPagosPage({super.key});

  @override
  State<MultiPagosPage> createState() => _MultiPagosPageState();
}

class _MultiPagosPageState extends State<MultiPagosPage> {
  static const Color _bg = Color(0xFF5B3CF6);
  final _internoCtrl = TextEditingController();

  int est = 0;        // Estudiante (1.00 Bs c/u)
  int adult = 0;      // Adulto (2.30 Bs c/u)
  int senior = 0;     // Adulto mayor (1.00 Bs c/u)

  static const double pEst = 1.00;
  static const double pAdult = 2.30;
  static const double pSenior = 1.00;

  String _bs(num v) => '${v.toStringAsFixed(2).replaceAll('.', ',')} Bs';

  double get _total => est * pEst + adult * pAdult + senior * pSenior;

  @override
  void dispose() {
    _internoCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final canPay = _internoCtrl.text.trim().isNotEmpty && _total > 0;
    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        backgroundColor: _bg,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back, color: Colors.white),
        ),
        centerTitle: true,
        title: const Text('MultiPago',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Interno / ID del conductor
              Container(
                decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: TextField(
                  controller: _internoCtrl,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    hintText: 'Interno', border: InputBorder.none,
                  ),
                  onChanged: (_) => setState(() {}),
                ),
              ),
              const SizedBox(height: 22),

              _fareRow(
                label: 'Estudiante',
                count: est,
                amount: est * pEst,
                onDec: () => setState(() => est = est > 0 ? est - 1 : 0),
                onInc: () => setState(() => est += 1),
              ),
              const SizedBox(height: 16),
              _fareRow(
                label: 'Adulto',
                count: adult,
                amount: adult * pAdult,
                onDec: () => setState(() => adult = adult > 0 ? adult - 1 : 0),
                onInc: () => setState(() => adult += 1),
              ),
              const SizedBox(height: 16),
              _fareRow(
                label: 'Adulto Mayor',
                count: senior,
                amount: senior * pSenior,
                onDec: () => setState(() => senior = senior > 0 ? senior - 1 : 0),
                onInc: () => setState(() => senior += 1),
              ),
              const SizedBox(height: 24),

              // Total
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('TOTAL:',
                      style: TextStyle(color: Colors.white, fontSize: 16)),
                  Text('-${_bs(_total)}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      )),
                ],
              ),
              const Spacer(),

              // Botón pagar
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: canPay ? _goConfirm : null,
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: _bg,
                    disabledBackgroundColor: Colors.white24,
                    disabledForegroundColor: Colors.white54,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('PAGAR',
                      style: TextStyle(fontWeight: FontWeight.w700)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _goConfirm() async {
  final interno = _internoCtrl.text.trim();
  final ok = await Navigator.push<bool>(
    context,
    MaterialPageRoute(builder: (_) => ConfirmPagoView(interno: interno)),
  );

  if (ok == true && mounted) {
    // Muestra check y lo cierra solo
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => const _AutoDismissSuccessDialog(),
    );
    // Al cerrarse el diálogo, vuelve al home (PassengerView)
    if (mounted) Navigator.pop(context);
  }
}


  Widget _fareRow({
    required String label,
    required int count,
    required double amount,
    required VoidCallback onDec,
    required VoidCallback onInc,
  }) {
    return Row(
      children: [
        Expanded(
          child: Text(
            '$label x $count',
            style: const TextStyle(color: Colors.white, fontSize: 15),
          ),
        ),
        _circleBtn(Icons.remove, onDec),
        const SizedBox(width: 12),
        Text('-${_bs(amount)}',
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
        const SizedBox(width: 12),
        _circleBtn(Icons.add, onInc),
      ],
    );
  }

  Widget _circleBtn(IconData icon, VoidCallback onTap) {
    return InkResponse(
      onTap: onTap,
      radius: 22,
      child: Container(
        width: 34,
        height: 34,
        decoration: BoxDecoration(
          color: Colors.white24, shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 1),
        ),
        child: Icon(icon, color: Colors.white),
      ),
    );
  }
}

class _SuccessDialog extends StatelessWidget {
  const _SuccessDialog();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: const Color(0xFF5B3CF6),
      insetPadding: const EdgeInsets.symmetric(horizontal: 56),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: SizedBox(
        height: 220,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            CircleAvatar(
              radius: 36,
              backgroundColor: Colors.white,
              child: Icon(Icons.check, size: 40, color: Color(0xFF5B3CF6)),
            ),
            SizedBox(height: 16),
            Text('Pasaje Confirmado',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
          ],
        ),
      ),
    );
  }
}
class _AutoDismissSuccessDialog extends StatefulWidget {
  const _AutoDismissSuccessDialog({super.key});
  @override
  State<_AutoDismissSuccessDialog> createState() =>
      _AutoDismissSuccessDialogState();
}

class _AutoDismissSuccessDialogState extends State<_AutoDismissSuccessDialog> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 1200), () {
      if (mounted) Navigator.of(context).pop(); // cierra el diálogo
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: const Color(0xFF5B3CF6),
      insetPadding: const EdgeInsets.symmetric(horizontal: 56),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: SizedBox(
        height: 220,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            CircleAvatar(
              radius: 36,
              backgroundColor: Colors.white,
              child: Icon(Icons.check, size: 40, color: Color(0xFF5B3CF6)),
            ),
            SizedBox(height: 16),
            Text('Pasaje Confirmado',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
          ],
        ),
      ),
    );
  }
}

