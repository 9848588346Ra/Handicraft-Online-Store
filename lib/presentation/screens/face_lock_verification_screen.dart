import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:handicraft_online_store/core/di/injection_container.dart';
import 'package:handicraft_online_store/core/services/biometric_auth_service.dart';
import 'package:handicraft_online_store/presentation/screens/Dashboard_screen.dart';

const Color _primaryPurple = Color(0xFF5E35B1);

/// Face Lock screen: opens camera (like tablet face lock setup), scans face,
/// and verifies against device's face lock key via system API.
class FaceLockVerificationScreen extends StatefulWidget {
  final bool isEnabling;
  final String? userEmail;
  final String? userName;

  const FaceLockVerificationScreen({
    super.key,
    this.isEnabling = false,
    this.userEmail,
    this.userName,
  });

  @override
  State<FaceLockVerificationScreen> createState() => _FaceLockVerificationScreenState();
}

class _FaceLockVerificationScreenState extends State<FaceLockVerificationScreen> with WidgetsBindingObserver {
  CameraController? _controller;
  List<CameraDescription>? _cameras;
  bool _isInitializing = true;
  bool _isVerifying = false;
  bool? _result;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initCamera();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller?.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (_controller == null || !_controller!.value.isInitialized) return;
    if (state == AppLifecycleState.inactive) {
      _controller?.dispose();
    } else if (state == AppLifecycleState.resumed) {
      _initCamera();
    }
  }

  Future<void> _initCamera() async {
    try {
      _cameras = await availableCameras();
      final frontCamera = _cameras!.firstWhere(
        (c) => c.lensDirection == CameraLensDirection.front,
        orElse: () => _cameras!.first,
      );
      _controller = CameraController(
        frontCamera,
        ResolutionPreset.medium,
        enableAudio: false,
      );
      await _controller!.initialize();
      if (!mounted) return;
      setState(() {
        _isInitializing = false;
        _errorMessage = null;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isInitializing = false;
        _errorMessage = 'Camera not available: $e';
      });
    }
  }

  Future<void> _startVerification() async {
    if (_isVerifying || _result != null) return;
    setState(() => _isVerifying = true);

    final bio = BiometricAuthService.instance;
    bool success = false;

    if (widget.isEnabling && widget.userEmail != null && widget.userName != null) {
      success = await bio.enableFaceLock(
        userEmail: widget.userEmail!,
        userName: widget.userName!,
      );
    } else {
      var session = await bio.authenticateAndRestoreSession();
      if (session == null && await bio.hasPinFallback()) {
        final pin = await _showPinEntryDialog();
        if (pin != null && mounted) {
          session = await bio.authenticateAndRestoreSession(pinInput: pin);
        }
      }
      if (session != null) {
        success = true;
        final container = InjectionContainer();
        if (!container.isInitialized) await container.init();
        await container.restoreSessionFromBiometricUseCase.call(session.email, session.name);
      }
    }

    if (!mounted) return;
    setState(() {
      _isVerifying = false;
      _result = success;
    });

    if (success && !widget.isEnabling) {
      await Future.delayed(const Duration(milliseconds: 800));
      if (!mounted) return;
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const DashboardScreen()),
        (route) => false,
      );
    }
  }

  Future<void> _showSetPinDialog() async {
    final pinController = TextEditingController();
    final confirmController = TextEditingController();
    final pin = await showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Set PIN for Face Lock'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Face unlock may not work on this device. Set a 4–6 digit PIN for quick sign-in.',
              style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: pinController,
              keyboardType: TextInputType.number,
              maxLength: 6,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'PIN',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                counterText: '',
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: confirmController,
              keyboardType: TextInputType.number,
              maxLength: 6,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Confirm PIN',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                counterText: '',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              final p = pinController.text.trim();
              final confirm = confirmController.text.trim();
              if (p.length >= 4 && p == confirm) Navigator.pop(ctx, p);
            },
            child: const Text('Enable', style: TextStyle(color: _primaryPurple, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
    if (pin != null && pin.length >= 4 && mounted && widget.userEmail != null && widget.userName != null) {
      final success = await BiometricAuthService.instance.enableFaceLockWithPin(
        userEmail: widget.userEmail!,
        userName: widget.userName!,
        pin: pin,
      );
      if (mounted) {
        setState(() => _result = success);
      }
    }
  }

  Future<String?> _showPinEntryDialog() async {
    final controller = TextEditingController();
    return showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Enter PIN'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          maxLength: 6,
          obscureText: true,
          autofocus: true,
          decoration: InputDecoration(
            labelText: 'PIN',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            counterText: '',
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              final pin = controller.text.trim();
              if (pin.length >= 4) Navigator.pop(ctx, pin);
            },
            child: const Text('OK', style: TextStyle(color: _primaryPurple, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.isEnabling ? 'Enable Face Lock' : 'Face Lock Sign In',
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: _result != null ? _buildResultView() : _buildCameraView(),
    );
  }

  Widget _buildCameraView() {
    if (_errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.camera_alt_outlined, size: 64, color: Colors.grey.shade400),
              const SizedBox(height: 16),
              Text(
                _errorMessage!,
                style: TextStyle(color: Colors.grey.shade300, fontSize: 15),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => _initCamera(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _primaryPurple,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    if (_isInitializing || _controller == null || !_controller!.value.isInitialized) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(color: _primaryPurple),
            const SizedBox(height: 16),
            Text(
              'Opening camera...',
              style: TextStyle(color: Colors.grey.shade400, fontSize: 15),
            ),
          ],
        ),
      );
    }

    return Stack(
      fit: StackFit.expand,
      children: [
        FittedBox(
          fit: BoxFit.cover,
          child: SizedBox(
            width: _controller!.value.previewSize?.height ?? 1,
            height: _controller!.value.previewSize?.width ?? 1,
            child: CameraPreview(_controller!),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withValues(alpha: 0.5),
                Colors.transparent,
                Colors.transparent,
                Colors.black.withValues(alpha: 0.7),
              ],
            ),
          ),
        ),
        Center(
          child: CustomPaint(
            size: const Size(260, 320),
            painter: _FaceOutlinePainter(),
          ),
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 48,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                Text(
                  'Position your face in the frame',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.9),
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _isVerifying ? null : _startVerification,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _primaryPurple,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    child: _isVerifying
                        ? const SizedBox(
                            height: 24,
                            width: 24,
                            child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
                          )
                        : const Text(
                            'Verify with Face',
                            style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600, fontFamily: 'open sans bold'),
                          ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Uses your device\'s face unlock',
                  style: TextStyle(color: Colors.white.withValues(alpha: 0.6), fontSize: 12),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildResultView() {
    final success = _result!;
    return Container(
      color: Colors.black,
      padding: const EdgeInsets.all(24),
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: success ? Colors.green.withValues(alpha: 0.2) : Colors.red.withValues(alpha: 0.2),
                shape: BoxShape.circle,
                border: Border.all(
                  color: success ? Colors.green : Colors.red,
                  width: 3,
                ),
              ),
              child: Icon(
                success ? Icons.check_circle : Icons.cancel,
                size: 56,
                color: success ? Colors.green : Colors.red,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              success
                  ? (widget.isEnabling ? 'Successfully Enabled' : 'Sign In Successful')
                  : 'Verification Unsuccessful',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: 'open sans bold',
                color: success ? Colors.green : Colors.red.shade400,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              success
                  ? (widget.isEnabling
                      ? 'Face Lock is active. Use it to sign in next time.'
                      : 'Welcome back!')
                  : 'Face unlock may not work on this device. Use PIN instead.',
              style: TextStyle(fontSize: 14, color: Colors.grey.shade400, height: 1.4),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            if (success)
              SizedBox(
                width: double.infinity,
                height: 52,
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context, true),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: _primaryPurple,
                    side: const BorderSide(color: _primaryPurple),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  child: const Text('Done', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                ),
              ),
            if (!success) ...[
              if (widget.isEnabling)
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: () => _showSetPinDialog(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _primaryPurple,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                    child: const Text('Use PIN Instead', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  ),
                ),
              if (widget.isEnabling) const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: OutlinedButton(
                  onPressed: () => setState(() => _result = null),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: _primaryPurple,
                    side: const BorderSide(color: _primaryPurple),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  child: const Text('Try Again', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                ),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text('Cancel', style: TextStyle(color: Colors.grey.shade400, fontSize: 15)),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _FaceOutlinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    final path = Path();
    final center = Offset(size.width / 2, size.height / 2);
    final rect = Rect.fromCenter(
      center: center,
      width: size.width * 0.85,
      height: size.height * 0.9,
    );
    path.addOval(rect);
    canvas.drawPath(path, paint);

    paint.strokeWidth = 1;
    paint.color = Colors.white.withValues(alpha: 0.3);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
