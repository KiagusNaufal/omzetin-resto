import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PinInputWidget extends StatefulWidget {
  final List<TextEditingController> controllers;
  final Function(String)? onCompleted;
  final bool obscure; 
  final dynamic autoFocus;

  const PinInputWidget({
    super.key,
    required this.controllers,
    this.autoFocus = true,
    this.onCompleted,
    this.obscure = true,
  });

  @override
  State<PinInputWidget> createState() => _PinInputWidgetState();
}

class _PinInputWidgetState extends State<PinInputWidget> {
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());
  List<bool> _obscureStates = List.generate(6, (_) => true);
  List<Timer?> _obscureTimers = List.generate(6, (_) => null);

  @override
  void initState() {
    super.initState();
    if (widget.autoFocus) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _focusNodes.first.requestFocus();
      });
    }
  }

  @override
  void dispose() {
    for (var controller in widget.controllers) {
      controller.dispose();
    }
    for (var focusNode in _focusNodes) {
      focusNode.dispose();
    }
    for (var timer in _obscureTimers) {
      timer?.cancel();
    }

    super.dispose();
  }

  void _handleBackspace(int index) {
    if (index > 0 && widget.controllers[index].text.isEmpty) {
      final prevIndex = index - 1;
      widget.controllers[prevIndex].clear();
      _focusNodes[prevIndex].requestFocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: widget.controllers.asMap().entries.map((entry) {
          final index = entry.key;
          final controller = entry.value;
          final focusNode = _focusNodes[index];

          return SizedBox(
            width: 44,
            height: 50,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: RawKeyboardListener(
                focusNode: FocusNode(),
                onKey: (RawKeyEvent event) {
                  if (event is RawKeyDownEvent &&
                      event.logicalKey == LogicalKeyboardKey.backspace) {
                    _handleBackspace(index);
                  }
                },
                child: TextField(
                  obscureText: widget.obscure ? _obscureStates[index] : false,
                  obscuringCharacter: '•',
                  controller: controller,
                  focusNode: focusNode,
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(1),
                  ],
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.grey[200],
                  ),
                  onChanged: (value) {
                    if (widget.obscure && value.isNotEmpty) {
                      setState(() {
                        _obscureStates[index] = false;
                      });

                      _obscureTimers[index]?.cancel();
                      _obscureTimers[index] = Timer(Duration(milliseconds: 400), () {
                        setState(() {
                          _obscureStates[index] = true;
                        });
                      });
                    }

                    if (value.length == widget.controllers.length) {
                      for (int i = 0; i < widget.controllers.length; i++) {
                        widget.controllers[i].text = value[i];
                      }
                      _focusNodes.last.requestFocus();
                      if (widget.onCompleted != null) {
                        widget.onCompleted!(value);
                      }
                      return;
                    }

                    if (value.length == 1 &&
                        index < widget.controllers.length - 1) {
                      _focusNodes[index + 1].requestFocus();
                    }

                    final allFilled =
                        widget.controllers.every((c) => c.text.length == 1);
                    if (allFilled && widget.onCompleted != null) {
                      final pin = widget.controllers.map((c) => c.text).join();
                      widget.onCompleted!(pin);
                    }
                  },
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
