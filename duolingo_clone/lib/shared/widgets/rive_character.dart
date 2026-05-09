import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

class RiveCharacter extends StatefulWidget {
  final String riveAssetPath;
  final double width;
  final double height;
  final String? animationName;
  final String? stateMachineName;
  final Map<String, dynamic>? stateMachineInputs;
  final BoxFit fit;

  const RiveCharacter({
    required this.riveAssetPath,
    this.width = 200,
    this.height = 200,
    this.animationName,
    this.stateMachineName,
    this.stateMachineInputs,
    this.fit = BoxFit.contain,
    super.key,
  });

  @override
  State<RiveCharacter> createState() => _RiveCharacterState();
}

class _RiveCharacterState extends State<RiveCharacter> {
  RiveAnimationController? _animationController;
  StateMachineController? _stateMachineController;
  final Map<String, SMIInput<dynamic>> _stateMachineInputMap = {};
  String? _error;
  Artboard? _artboard;

  bool get _useStateMachine => widget.stateMachineName != null;

  @override
  void initState() {
    super.initState();
    _initializeController();
  }

  void _initializeController() {
    if (!_useStateMachine) {
      try {
        final animationName = widget.animationName?.isNotEmpty == true
            ? widget.animationName!
            : 'idle';
        _animationController = SimpleAnimation(animationName);
      } catch (e) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted) return;
          setState(() {
            _error = 'Failed to load animation';
          });
        });
      }
    }
  }

  @override
  void didUpdateWidget(RiveCharacter oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (_useStateMachine != (oldWidget.stateMachineName != null)) {
      _initializeController();
    }

    if (!_useStateMachine && widget.animationName != oldWidget.animationName) {
      _changeAnimation(widget.animationName ?? 'idle');
    }

    if (_useStateMachine && widget.stateMachineInputs != null) {
      _updateStateMachineInputs();
    }
  }

  void _changeAnimation(String animationName) {
    if (_artboard != null && _animationController != null) {
      try {
        _animationController!.dispose();
        _animationController = SimpleAnimation(animationName);
        _artboard!.addController(_animationController!);
      } catch (e) {
        debugPrint('Failed to change animation: $e');
      }
    }
  }

  void _updateStateMachineInputs() {
    if (_stateMachineController == null || widget.stateMachineInputs == null) return;

    widget.stateMachineInputs!.forEach((key, value) {
      final input = _stateMachineInputMap[key];
      if (input == null) {
        debugPrint('Input $key not found in map, skipping update');
        return;
      }

      try {
        if (value is bool && input is SMIInput<bool>) {
          input.value = value;
          debugPrint('Updated $key (bool) to: $value');
        } else if (value is num && input is SMIInput<double>) {
          input.value = value.toDouble();
          debugPrint('Updated $key (double) to: ${value.toDouble()}');
        } else if (value is int && input is SMIInput<int>) {
          input.value = value;
          debugPrint('Updated $key (int) to: $value');
        } else if (input is SMITrigger) {
          input.fire();
          debugPrint('Fired trigger $key');
        } else {
          debugPrint('Type mismatch for $key: expected ${input.runtimeType}, got ${value.runtimeType}');
        }
      } catch (e) {
        debugPrint('Error updating $key: $e');
      }
    });
  }

  @override
  void dispose() {
    _animationController?.dispose();
    _stateMachineController?.dispose();
    super.dispose();
  }

  void _onRiveInit(Artboard artboard) {
    _artboard = artboard;
    
    debugPrint('Available animations: ${artboard.animations.map((a) => a.name).toList()}');
    debugPrint('Available state machines: ${artboard.stateMachines.map((sm) => sm.name).toList()}');

    if (_useStateMachine) {
      debugPrint('Looking for state machine: ${widget.stateMachineName}');
      _stateMachineController = StateMachineController.fromArtboard(artboard, widget.stateMachineName!);
      if (_stateMachineController == null) {
        setState(() {
          _error = 'State machine "${widget.stateMachineName}" not found';
        });
        return;
      }

      artboard.addController(_stateMachineController!);
      
      debugPrint('Available inputs in state machine:');
      for (final input in _stateMachineController!.inputs) {
        debugPrint('  - ${input.name} (${input.runtimeType})');
      }
      
      widget.stateMachineInputs?.forEach((key, value) {
        // Try to find input by name directly from the inputs list
        SMIInput<dynamic>? input;
        for (var smiInput in _stateMachineController!.inputs) {
          if (smiInput.name == key) {
            input = smiInput;
            break;
          }
        }
        
        if (input != null) {
          _stateMachineInputMap[key] = input;
          debugPrint('Found input: $key (${input.runtimeType}), setting value: $value');
        } else {
          debugPrint('Input not found: $key. Available inputs: ${_stateMachineController!.inputs.map((i) => i.name).toList()}');
        }
      });
      _updateStateMachineInputs();
    } else if (widget.animationName != null) {
      debugPrint('Looking for animation: ${widget.animationName}');
      final animation = artboard.animations.firstWhere(
        (anim) => anim.name == widget.animationName,
        orElse: () => artboard.animations.first,
      );
      debugPrint('Using animation: ${animation.name}');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_error != null) {
      return Container(
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.grey.shade200,
        ),
        child: Center(
          child: Text(
            _error!,
            style: const TextStyle(color: Colors.red),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    return Container(
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.grey.shade100,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(25),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: RiveAnimation.asset(
          widget.riveAssetPath,
          controllers: _useStateMachine ? (_stateMachineController != null ? [_stateMachineController!] : []) : [_animationController!],
          fit: widget.fit,
          onInit: _onRiveInit,
          placeHolder: Container(
            color: Colors.grey.shade200,
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          ),
        ),
      ),
    );
  }
}

