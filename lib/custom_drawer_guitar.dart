import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'diagonal_clipper.dart';

class CustomGuitarDrawer extends StatefulWidget {
  final Widget child;

  const CustomGuitarDrawer({Key key, this.child}) : super(key: key);

  static CustomGuitarDrawerState of(BuildContext context) =>
      context.findAncestorStateOfType<CustomGuitarDrawerState>();

  @override
  CustomGuitarDrawerState createState() => new CustomGuitarDrawerState();
}

class CustomGuitarDrawerState extends State<CustomGuitarDrawer>
    with SingleTickerProviderStateMixin {
  AnimationController animationController;
  bool _canBeDragged = false;
  final double maxSlide = 300.0;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 250),
    );
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  void toggle() => animationController.isDismissed
      ? animationController.forward()
      : animationController.reverse();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragStart: _onDragStart,
      onHorizontalDragUpdate: _onDragUpdate,
      onHorizontalDragEnd: _onDragEnd,
      behavior: HitTestBehavior.translucent,
      onTap: toggle,
      child: AnimatedBuilder(
        animation: animationController,
        builder: (context, _) {
          return Material(
            color: Colors.grey,
            child: Stack(
              children: <Widget>[
                Transform.translate(
                  offset: Offset(maxSlide * (animationController.value - 1), 0),
                  child: Transform(
                    transform: Matrix4.identity()
                      ..setEntry(3, 2, 0.001)
                      ..rotateY(math.pi / 2 * (1 - animationController.value)),
                    alignment: Alignment.centerRight,
                    child: MyDrawer(),
                  ),
                ),
                Transform.translate(
                  offset: Offset(maxSlide * animationController.value, 0),
                  child: Transform(
                    transform: Matrix4.identity()
                      ..setEntry(3, 2, 0.001)
                      ..rotateY(-math.pi * animationController.value / 2),
                    alignment: Alignment.centerLeft,
                    child: widget.child,
                  ),
                ),
                Positioned(
                  top: 12.0 + MediaQuery.of(context).padding.top,
                  left: 4.0 + animationController.value * maxSlide,
                  child: IconButton(
                    icon: Icon(Icons.menu),
                    onPressed: toggle,
                    iconSize: 34.0,
                  ),
                ),
                Positioned(
                  top: 12.0 + MediaQuery.of(context).padding.top,
                  left: animationController.value *
                      MediaQuery.of(context).size.width,
                  width: MediaQuery.of(context).size.width,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 60.0, top: 5.0),
                    child: Text(
                      'My Tasks',
                      textAlign: TextAlign.start,
                      style: new TextStyle(fontSize: 34.0,),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _onDragStart(DragStartDetails details) {
    bool isDragOpenFromLeft = animationController.isDismissed;
    bool isDragCloseFromRight = animationController.isCompleted;
    _canBeDragged = isDragOpenFromLeft || isDragCloseFromRight;
  }

  void _onDragUpdate(DragUpdateDetails details) {
    if (_canBeDragged) {
      double delta = details.primaryDelta / maxSlide;
      animationController.value += delta;
    }
  }

  void _onDragEnd(DragEndDetails details) {
    //I have no idea what it means, copied from Drawer
    double _kMinFlingVelocity = 365.0;

    if (animationController.isDismissed || animationController.isCompleted) {
      return;
    }
    if (details.velocity.pixelsPerSecond.dx.abs() >= _kMinFlingVelocity) {
      double visualVelocity = details.velocity.pixelsPerSecond.dx /
          MediaQuery.of(context).size.width;

      animationController.fling(velocity: visualVelocity);
    } else if (animationController.value < 0.5) {
      animationController.reverse();
    } else {
      animationController.forward();
    }
  }
}

class MyDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      height: double.infinity,
      child: Scaffold(
        body: Material(
          color: Colors.blueGrey[900],
          child: Stack(
            children: [
              Positioned.fill(
                bottom: null,
                child: ClipPath(
                  clipper: DialogonalClipper(),
                  child: Image.asset(
                    'images/birds.jpg',
                    fit: BoxFit.cover,
                    height: 256.0,
                    colorBlendMode: BlendMode.srcOver,
                    color: Color.fromARGB(120, 20, 10, 40),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 16.0, top: 256.0 / 3.0),
                child: Row(
                  children: <Widget>[
                    CircleAvatar(
                      minRadius: 28.0,
                      maxRadius: 28.0,
                      backgroundImage: AssetImage('images/myPic.jpg'),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text(
                            'Joshua Kasasira',
                            style: TextStyle(
                                fontSize: 26.0,
                                color: Colors.white,
                                fontWeight: FontWeight.w400),
                          ),
                          Text(
                            'Software Developer',
                            style: TextStyle(
                                fontSize: 14.0,
                                color: Colors.white,
                                fontWeight: FontWeight.w300),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 256.0),
                child: Theme(
                  data: ThemeData(brightness: Brightness.dark),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      ListTile(
                        leading: Icon(Icons.new_releases),
                        title: Text('News'),
                      ),
                      ListTile(
                        leading: Icon(Icons.star),
                        title: Text('Favourites'),
                      ),
                      ListTile(
                        leading: Icon(Icons.map),
                        title: Text('Map'),
                      ),
                      ListTile(
                        leading: Icon(Icons.settings),
                        title: Text('Settings'),
                      ),
                      ListTile(
                        leading: Icon(Icons.person),
                        title: Text('Profile'),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
