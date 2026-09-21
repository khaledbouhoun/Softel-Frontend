import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:get/state_manager.dart';
import 'package:softel/controller/auth/login_controller.dart';
import 'package:softel/core/constant/color.dart';
import 'package:softel/core/constant/imageasset.dart';
import 'package:softel/view/widget/loadingwidget.dart';

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FC),
      body: GetBuilder<LoginController>(
        init: LoginController(),
        builder: (controller) {
          if (controller.isLoading) {
            return const Center(child: Loadingwidget());
          }

          final Color primary = controller.company?.clsClr1 ?? AppColor.primaryColor;

          return Stack(
            children: [
              /// 🌫 Background depth (VERY subtle)
              Positioned(top: -100, left: -60, child: _AmbientCircle(color: primary, size: 200)),
              Positioned(bottom: -120, right: -80, child: _AmbientCircle(color: primary, size: 240)),

              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 28),
                  child: Column(
                    children: [
                      const Spacer(flex: 3),

                      /// 🔹 Subtitle
                      _SubtitlePill(primary: primary),

                      const Spacer(flex: 1),

                      /// 🔹 Logo
                      _LogoCard(controller: controller, primary: primary),

                      const Spacer(flex: 1),

                      /// 🔹 Title
                      Text(
                        controller.company?.clsNom ?? '',
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 30, fontWeight: FontWeight.w800, color: Color(0xFF0F172A)),
                      ),

                      const Spacer(flex: 4),

                      /// 🔹 CTA
                      _GoogleButton(primary: primary, onPressed: controller.loginWithGoogle),

                      const Spacer(flex: 1),

                      /// 🔹 Footer
                      const _EnhancedFooter(),

                      const Spacer(flex: 3),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _GoogleButton extends StatefulWidget {
  final Color primary;
  final VoidCallback onPressed;

  const _GoogleButton({required this.primary, required this.onPressed});

  @override
  State<_GoogleButton> createState() => _GoogleButtonState();
}

class _GoogleButtonState extends State<_GoogleButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        widget.onPressed();
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 120),
        height: 56,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white, // ✅ keep Google identity
          borderRadius: BorderRadius.circular(16),

          /// 👇 Smart border instead of colored background
          border: Border.all(color: _pressed ? widget.primary.withValues(alpha: 0.4) : const Color(0xFFE5E7EB)),

          /// 👇 subtle premium shadow
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: _pressed ? 0.04 : 0.08),
              blurRadius: _pressed ? 8 : 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            /// 🌈 Google logo (always visible)
            Image.asset(AppImageAsset.google, height: 22),

            const SizedBox(width: 12),

            /// 🧠 Smart text color
            const Text(
              "Continue with Google",
              style: TextStyle(
                color: Color(0xFF0F172A), // dark, readable
                fontWeight: FontWeight.w600,
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AmbientCircle extends StatelessWidget {
  final Color color;
  final double size;

  const _AmbientCircle({required this.color, required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(shape: BoxShape.circle, color: color.withValues(alpha: 0.08)),
    );
  }
}

class _LogoCard extends StatelessWidget {
  final LoginController controller;
  final Color primary;

  const _LogoCard({required this.controller, required this.primary});

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: controller.company?.clsNo?.toString() ?? 'logo',
      child: Container(
        width: Get.width * 0.8,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: const Color(0xFFE5E7EB)),
          boxShadow: const [BoxShadow(color: Color(0x0A000000), blurRadius: 20, offset: Offset(0, 8))],
        ),
        child: CachedNetworkImage(
          imageUrl: controller.company?.clsImg ?? '',
          fit: BoxFit.scaleDown,
          placeholder: (_, __) => CircularProgressIndicator(color: primary),
          errorWidget: (_, __, ___) => SvgPicture.asset(AppSvg.galleryremove),
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════
// Enhanced Logo Card with Glass Morphism
// ══════════════════════════════════════════════
class _EnhancedLogoCard extends StatefulWidget {
  final Color primary;
  final LoginController controller;

  const _EnhancedLogoCard({required this.primary, required this.controller});

  @override
  State<_EnhancedLogoCard> createState() => _EnhancedLogoCardState();
}

class _EnhancedLogoCardState extends State<_EnhancedLogoCard> with TickerProviderStateMixin {
  late AnimationController _floatController;

  @override
  void initState() {
    super.initState();
    _floatController = AnimationController(vsync: this, duration: const Duration(seconds: 3))..repeat(reverse: true);
  }

  @override
  void dispose() {
    _floatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: widget.controller.company?.clsNo?.toString() ?? 'logo',
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0, end: 1),
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeOut,
        builder: (context, value, child) {
          return Transform.scale(
            scale: value,
            child: Opacity(opacity: value, child: child),
          );
        },
        child: AnimatedBuilder(
          animation: _floatController,
          builder: (context, child) {
            return Transform.translate(offset: Offset(0, Tween<double>(begin: 0, end: 8).evaluate(_floatController)), child: child);
          },
          child: Container(
            width: Get.width * 0.8,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.7),
              borderRadius: BorderRadius.circular(32),
              border: Border.all(color: widget.primary.withValues(alpha: 0.15), width: 2),
              boxShadow: [
                // Glass glow
                BoxShadow(color: widget.primary.withValues(alpha: 0.25), blurRadius: 40, spreadRadius: 5, offset: const Offset(0, 16)),
                // Inner light
                BoxShadow(color: Colors.white.withValues(alpha: 0.8), blurRadius: 20, offset: const Offset(-8, -8)),
                // Subtle dark shadow
                BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 12, offset: const Offset(0, 4)),
              ],
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Colors.white.withValues(alpha: 0.9), Colors.white.withValues(alpha: 0.5)],
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: CachedNetworkImage(
                  imageUrl: widget.controller.company?.clsImg ?? '',
                  fit: BoxFit.contain,
                  placeholder: (context, url) => CircularProgressIndicator(color: widget.primary, strokeWidth: 2.5),
                  errorWidget: (context, url, error) => SvgPicture.asset(AppSvg.galleryremove, color: widget.primary),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════
// Animated Title
// ══════════════════════════════════════════════

// ══════════════════════════════════════════════
// Premium Subtitle Pill
// ══════════════════════════════════════════════
class _SubtitlePill extends StatelessWidget {
  final Color primary;

  const _SubtitlePill({required this.primary});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 900),
      curve: Curves.easeOut,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(offset: Offset(0, 16 * (1 - value)), child: child),
        );
      },
      child: Column(
        children: [
          /// 👋 Title
          Text(
            "Welcome back",
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: const Color(0xFF0F172A), letterSpacing: -0.4),
          ),

          const SizedBox(height: 6),

          /// ✨ Subtitle
          Text(
            'sign_in_to_continue'.tr,
            style: TextStyle(fontSize: 14, color: const Color(0xFF64748B), fontWeight: FontWeight.w500, letterSpacing: 0.2),
          ),

          const SizedBox(height: 12),

          /// 🔹 Accent line (pro touch)
          Container(
            width: 40,
            height: 3,
            decoration: BoxDecoration(color: primary, borderRadius: BorderRadius.circular(10)),
          ),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════
// Enhanced Google Sign-In Button
// ══════════════════════════════════════════════
class _EnhancedGoogleSignInButton extends StatefulWidget {
  final Color primary;
  final VoidCallback onPressed;

  const _EnhancedGoogleSignInButton({required this.primary, required this.onPressed});

  @override
  State<_EnhancedGoogleSignInButton> createState() => _EnhancedGoogleSignInButtonState();
}

class _EnhancedGoogleSignInButtonState extends State<_EnhancedGoogleSignInButton> with TickerProviderStateMixin {
  late AnimationController _scaleController;
  late AnimationController _shimmerController;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(vsync: this, duration: const Duration(milliseconds: 140));
    _shimmerController = AnimationController(vsync: this, duration: const Duration(seconds: 2))..repeat();
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _shimmerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 1400),
      curve: Curves.easeOut,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(offset: Offset(0, 20 * (1 - value)), child: child),
        );
      },
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: GestureDetector(
          onTapDown: (_) => _scaleController.forward(),
          onTapUp: (_) {
            _scaleController.reverse();
            widget.onPressed();
          },
          onTapCancel: () => _scaleController.reverse(),
          child: ScaleTransition(
            scale: Tween<double>(begin: 1.0, end: 0.95).animate(CurvedAnimation(parent: _scaleController, curve: Curves.easeOut)),
            child: Container(
              width: double.infinity,
              height: 62,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: _isHovered ? widget.primary.withValues(alpha: 0.3) : const Color(0xFFE5E7EB), width: 1.5),
                boxShadow: [
                  BoxShadow(
                    color: widget.primary.withValues(alpha: _isHovered ? 0.2 : 0.12),
                    blurRadius: _isHovered ? 28 : 20,
                    spreadRadius: 2,
                    offset: const Offset(0, 8),
                  ),
                  BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 8, offset: const Offset(0, 2)),
                ],
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Colors.white, _isHovered ? widget.primary.withValues(alpha: 0.02) : Colors.white],
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(AppImageAsset.google, height: 24),
                  const SizedBox(width: 14),
                  Text(
                    'google'.tr,
                    style: TextStyle(color: const Color(0xFF0F172A), fontSize: 16, fontWeight: FontWeight.w800, letterSpacing: 0.1),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════
// Animated Ambient Blob
// ══════════════════════════════════════════════
class _AnimatedAmbientBlob extends StatefulWidget {
  final Color color;
  final double size;
  final double opacity;
  final Duration duration;
  final Duration delay;

  const _AnimatedAmbientBlob({
    required this.color,
    required this.size,
    required this.opacity,
    required this.duration,
    this.delay = Duration.zero,
  });

  @override
  State<_AnimatedAmbientBlob> createState() => _AnimatedAmbientBlobState();
}

class _AnimatedAmbientBlobState extends State<_AnimatedAmbientBlob> with TickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration)..repeat(reverse: true);

    Future.delayed(widget.delay, () {
      if (mounted) {
        _controller.forward();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, Tween<double>(begin: 0, end: 16).evaluate(_controller)),
          child: Transform.scale(scale: Tween<double>(begin: 0.95, end: 1.05).evaluate(_controller), child: child),
        );
      },
      child: Container(
        width: widget.size,
        height: widget.size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [
              widget.color.withValues(alpha: widget.opacity),
              widget.color.withValues(alpha: widget.opacity * 0.5),
              Colors.transparent,
            ],
            stops: const [0, 0.6, 1],
          ),
          boxShadow: [BoxShadow(color: widget.color.withValues(alpha: widget.opacity * 0.3), blurRadius: 50, spreadRadius: 10)],
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════
// Enhanced Footer
// ══════════════════════════════════════════════
class _EnhancedFooter extends StatelessWidget {
  const _EnhancedFooter();

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 1600),
      curve: Curves.easeOut,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(offset: Offset(0, 10 * (1 - value)), child: child),
        );
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'powered_by'.tr,
            style: const TextStyle(color: Color(0xFFB0B7C3), fontSize: 13, letterSpacing: 0.3, fontWeight: FontWeight.w500),
          ),
          const SizedBox(width: 8),
          Image.asset(AppImageAsset.logo, height: 28),
        ],
      ),
    );
  }
}
