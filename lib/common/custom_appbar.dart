import 'package:flutter/material.dart';

AppBar getAppBarWithArrowBack(BuildContext context, String title) {
  return AppBar(
    leading: Builder(
      builder: (context) => IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () => Navigator.pop(context),
      ),
    ),
    title: Text(title),
  );
}

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget firstIcon;
  final Widget child;
  final String title;
  final double height;
  final double childHeight;
  final String backgroundImage;
  final Widget bottom;

  CustomAppBar({
    Key? key,
    required this.height,
    required this.backgroundImage,
    required this.title,
    required this.childHeight,
    required this.firstIcon,
    required this.child,
    required this.bottom,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox.fromSize(
      size: preferredSize,
      child: LayoutBuilder(
        builder: (context, constraint) {
          return SafeArea(
            child: Column(
              children: [
                Stack(
                  children: <Widget>[
                    ClipPath(
                      clipper: _AppBarProfileClipper(this.height + (this.childHeight / 2)),
                      child: Container(
                        width: double.maxFinite,
                        height: this.height,
                        alignment: Alignment.topCenter,
                        child: Image(
                          image: NetworkImage(this.backgroundImage ?? ''),
                          fit: BoxFit.cover,
                          height: this.height,
                          width: MediaQuery.of(context).size.width,
                        ),
                      ),
                    ),
                    Positioned.fill(
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: child,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        firstIcon,
                        // Text(
                        //   title,
                        // ),
                        SizedBox(),
                        // IconButton(
                        //   icon: Icon(
                        //     Icons.settings,
                        //     // color: Colors.white,
                        //   ),
                        //   onPressed: () {},
                        // ),
                      ],
                    ),
                  ],
                ),
                this.bottom,
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(this.height + this.childHeight) ;
}

class _AppBarProfileClipper extends CustomClipper<Path> {
  final double childHeight;

  _AppBarProfileClipper(this.childHeight);

  @override
  Path getClip(Size size) {
    var path = Path();
    path.moveTo(0, size.height - 40.0);
    path.quadraticBezierTo(
        size.width / 2, size.height, size.width, size.height - 40.0);
    path.lineTo(size.width, 0);
    path.lineTo(0, 0);
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => true;
}
