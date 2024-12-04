import 'package:flutter/material.dart';

class AppButton extends StatefulWidget {
  const AppButton(
      {super.key,
      this.title = "",
      this.child,
      this.titleColor = Colors.white,
      this.btnBackgroundColor = Colors.white,
      this.titleFontSize = 20,
      this.titlePadding = const EdgeInsets.symmetric(horizontal: 15.0),
      this.borderRadius = 10,
      this.fontFamily = "Raleway",
      this.titleFontWeight = FontWeight.w600,
      required this.onPressed,
      this.isTextBtn = false,
      this.alignment,
      this.disableBtn = false,
      this.height = 40});

  final String title;
  final Widget? child;
  final EdgeInsetsGeometry titlePadding;
  final Alignment? alignment;
  final String fontFamily;
  final bool isTextBtn;

  final Color titleColor;
  final Color btnBackgroundColor;

  final bool disableBtn;

  final double titleFontSize;
  final double borderRadius;
  final FontWeight titleFontWeight;
  final double height;
  final void Function() onPressed;

  @override
  State<AppButton> createState() => _AppButtonState();
}

class _AppButtonState extends State<AppButton> with TickerProviderStateMixin {
  late AnimationController _controller;
  final Duration _animationDuration = const Duration(milliseconds: 200);
  final Tween<double> _tween = Tween<double>(begin: 1.0, end: 0.8);

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: _animationDuration,
    )..addListener(() {
        setState(() {});
      });
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _tween.animate(
        CurvedAnimation(
          parent: _controller,
          curve: Curves.easeOut,
          reverseCurve: Curves.easeIn,
        ),
      ),
      child: Container(
        alignment: widget.alignment,
        height: widget.height,
        decoration: widget.isTextBtn
            ? null
            : BoxDecoration(
                borderRadius: BorderRadius.circular(widget.borderRadius),
                gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: widget.disableBtn
                      ? [Colors.grey]
                      : [
                          widget.btnBackgroundColor,
                          widget.btnBackgroundColor,
                          widget.btnBackgroundColor,
                          // Color(0xFF1B54B7)
                        ],
                ),
              ),
        child: ElevatedButton(
          onPressed: widget.disableBtn
              ? null
              : () async {
                  await _controller
                      .forward()
                      .then((value) => _controller.reverse());

                  widget.onPressed();
                },
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.zero,
            elevation: 0,
            overlayColor: Colors.transparent,
            backgroundColor: Colors.transparent,
            disabledBackgroundColor: Colors.transparent,
            disabledForegroundColor: Colors.transparent,
            minimumSize: const Size(0, 0),
            side: BorderSide.none,
            foregroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            surfaceTintColor: Colors.transparent,
          ),
          child: widget.child ??
              Padding(
                padding: widget.titlePadding,
                child: Text(
                  widget.title,
                  style: TextStyle(
                      color: widget.titleColor,
                      fontSize: widget.titleFontSize,
                      fontFamily: widget.fontFamily,
                      fontWeight: widget.titleFontWeight),
                ),
              ),
        ),
      ),
    );
  }
}
