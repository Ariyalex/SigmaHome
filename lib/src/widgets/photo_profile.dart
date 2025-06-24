import 'package:flutter/widgets.dart';

class PhotoProfile extends StatelessWidget {
  final double size;
  final double borderRadius;
  const PhotoProfile({
    super.key,
    this.size = 40,
    this.borderRadius = 16,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      clipBehavior: Clip.antiAlias,
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusGeometry.circular(borderRadius),
        ),
      ),
      child: Image.asset('assets/images/profile.jpg'),
    );
  }
}
