import 'package:flutter/material.dart';

class ImageControls extends StatelessWidget {
  final Widget child;
  const ImageControls({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    const edgeInsets = EdgeInsets.symmetric(horizontal: 168);
    return Padding(
      padding: edgeInsets,
      child: Container(
        width: double.infinity,
        //decoration: _createImageShape(),
        child: child,
      ),
    );
  }

  BoxDecoration _createImageShape() => BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
          boxShadow: const [
            BoxShadow(
                color: Color.fromARGB(31, 3, 192, 255),
                blurRadius: 15,
                offset: Offset(0, 5))
          ]);
}
