import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:math_expressions/math_expressions.dart';

class KalkulatorScreen extends StatefulWidget {
  const KalkulatorScreen({super.key});
  @override
  State<KalkulatorScreen> createState() => _KalkulatorScreenState();
}

class _KalkulatorScreenState extends State<KalkulatorScreen> {
  String _display = '0';
  String _expression = '';
  bool _justEvaluated = false;

  final _buttons = [
    ['C', '±', '%', '÷'],
    ['7', '8', '9', '×'],
    ['4', '5', '6', '−'],
    ['1', '2', '3', '+'],
    ['0', '.', '⌫', '='],
  ];

  void _press(String b) {
    setState(() {
      if (b == 'C') {
        _display = '0';
        _expression = '';
        _justEvaluated = false;
      } else if (b == '⌫') {
        if (_display.length > 1) {
          _display = _display.substring(0, _display.length - 1);
        } else {
          _display = '0';
        }
        _expression = _expression.isEmpty ? '' : _expression.substring(0, _expression.length - 1);
      } else if (b == '=') {
        try {
          final expr = _expression
              .replaceAll('×', '*')
              .replaceAll('÷', '/')
              .replaceAll('−', '-')
              .replaceAll('%', '/100');
          final p = Parser();
          final e = p.parse(expr);
          final result = e.evaluate(EvaluationType.REAL, ContextModel());
          final res = result % 1 == 0 ? result.toInt().toString() : result.toStringAsFixed(8).replaceAll(RegExp(r'0+$'), '');
          _display = res;
          _expression = res;
          _justEvaluated = true;
        } catch (_) {
          _display = 'Error';
          _expression = '';
        }
      } else if (b == '±') {
        if (_display.startsWith('-')) {
          _display = _display.substring(1);
          _expression = _expression.substring(1);
        } else {
          _display = '-$_display';
          _expression = '-$_expression';
        }
      } else if (b == '%') {
        _expression += '%';
        _display = b;
      } else if (['+', '−', '×', '÷'].contains(b)) {
        if (_justEvaluated) _justEvaluated = false;
        _expression += b;
        _display = b;
      } else {
        if (_justEvaluated) {
          _expression = b;
          _display = b;
          _justEvaluated = false;
        } else {
          if (_display == '0' && b != '.') {
            _display = b;
            _expression = _expression.isEmpty ? b : _expression + b;
          } else {
            _display += b;
            _expression += b;
          }
        }
      }
    });
  }

  bool _isOp(String b) => ['+', '−', '×', '÷', '='].contains(b);
  bool _isClear(String b) => ['C', '±', '%'].contains(b);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A2E),
      appBar: AppBar(
        title: const Text('Kalkulator Ilmiah'),
        backgroundColor: const Color(0xFF1A1A2E),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 2,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              alignment: Alignment.bottomRight,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(_expression,
                      style: GoogleFonts.poppins(color: Colors.white38, fontSize: 18),
                      maxLines: 2, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 8),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      _display,
                      style: GoogleFonts.poppins(
                          color: Colors.white, fontSize: 56, fontWeight: FontWeight.w300),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF16213E),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
            ),
            child: Column(
              children: _buttons.map((row) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    children: row.map((b) {
                      return Expanded(
                        flex: b == '0' ? 1 : 1,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 6),
                          child: _CalcButton(
                            label: b,
                            onTap: () => _press(b),
                            isOp: _isOp(b),
                            isClear: _isClear(b),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class _CalcButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final bool isOp;
  final bool isClear;
  const _CalcButton({required this.label, required this.onTap, this.isOp = false, this.isClear = false});

  Color get _bg {
    if (label == '=') return const Color(0xFF6C63FF);
    if (isOp) return const Color(0xFFFF6B35).withOpacity(0.85);
    if (isClear) return const Color(0xFF4A4E69);
    return const Color(0xFF22304A);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: _bg,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Container(
          height: 64,
          alignment: Alignment.center,
          child: Text(label,
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 22,
                fontWeight: isOp || label == '=' ? FontWeight.bold : FontWeight.normal,
              )),
        ),
      ),
    );
  }
}
