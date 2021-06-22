import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'animated_fab.dart';
import 'custom_drawer_guitar.dart';
import 'initial_list.dart';
import 'list_model.dart';
import 'reversed_diagonal_clipper.dart';
import 'task_row.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: CustomGuitarDrawer(child: MainPage()),
    );
  }
}

class MainPage extends StatefulWidget {
  MainPage({Key key}) : super(key: key);

  @override
  _MainPageState createState() => new _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final GlobalKey<AnimatedListState> _listKey =
      new GlobalKey<AnimatedListState>();
  final double _imageHeight = 256.0;
  ListModel listModel;
  bool showOnlyCompleted = false;

  @override
  void initState() {
    super.initState();
    listModel = new ListModel(_listKey, tasks);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Stack(
        children: <Widget>[
          _buildTimeline(),
          // _buildImage(),
          // _buildTopHeader(),
          _buildMyTasksHeader(),
          _buildBottomPart(),
          _buildFab(),
        ],
      ),
      // floatingActionButton: AnimatedFab(
      //     onClick: _changeFilterState,
      //   ),
    );
  }

  Widget _buildFab() {
    return new Positioned(
        bottom: -10.0,
        right: -45.0,
        child: new AnimatedFab(
          onClick: _changeFilterState,
        ));
  }

  void _changeFilterState() {
    showOnlyCompleted = !showOnlyCompleted;
    tasks.where((task) => !task.completed).forEach((task) {
      if (showOnlyCompleted) {
        listModel.removeAt(listModel.indexOf(task));
      } else {
        listModel.insert(tasks.indexOf(task), task);
      }
    });
  }

  // Widget _buildImage() {
  //   return new Positioned.fill(
  //     bottom: null,
  //     child: new ClipPath(
  //       clipper: new ReversedDialogonalClipper(),
  //         child: new Image.asset(
  //           'images/birds.jpg',
  //           fit: BoxFit.cover,
  //           height: 256.0,
  //           colorBlendMode: BlendMode.srcOver,
  //           color: new Color.fromARGB(120, 20, 10, 40),
  //         ),
  //     ),
  //   );
  // }

  Widget _buildBottomPart() {
    return new Padding(
      padding: new EdgeInsets.only(top: _imageHeight / 2),
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // _buildMyTasksHeader(),
          _buildTasksList(),
        ],
      ),
    );
  }

  Widget _buildTasksList() {
    return new Expanded(
      child: new AnimatedList(
        initialItemCount: tasks.length,
        key: _listKey,
        itemBuilder: (context, index, animation) {
          return new TaskRow(
            task: listModel[index],
            animation: animation,
          );
        },
      ),
    );
  }

  Widget _buildMyTasksHeader() {
    return new Padding(
      padding: new EdgeInsets.only(left: 60.0, top: _imageHeight / 3.0),
      child: Row(
        children: [
          Expanded(
            child: new Text(
              'FEBRUARY 8, 2015',
              textAlign: TextAlign.start,
              style: new TextStyle(fontSize: 12.0),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeline() {
    return new Positioned(
      top: _imageHeight / 2.0,
      bottom: 0.0,
      left: 32.0,
      child: new Container(
        width: 1.0,
        color: Colors.grey[300],
      ),
    );
  }
}

// Widget _buildTopHeader() {
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 32.0),
  //     child: Row(
  //       children: <Widget>[
  //         Expanded(
  //           child: Padding(
  //             padding: const EdgeInsets.only(left: 40.0, top: 8.0),
  //             child: Text(
  //               'My Tasks',
  //               style: new TextStyle(fontSize: 34.0, color: Colors.white),
  //             ),
  //             // Text(
  //             //   "Timeline",
  //             //   style: TextStyle(
  //             //       fontSize: 20.0,
  //             //       color: Colors.white,
  //             //       fontWeight: FontWeight.w300),
  //             // ),
  //           ),
  //         ),
  //         Icon(Icons.linear_scale, color: Colors.white),
  //       ],
  //     ),
  //   );
  // }

  // Widget _buildProfileRow() {
  //   return new Padding(
  //     padding: new EdgeInsets.only(left: 16.0, top: _imageHeight / 2.5),
  //     child: new Row(
  //       children: <Widget>[
  //         new CircleAvatar(
  //           minRadius: 28.0,
  //           maxRadius: 28.0,
  //           backgroundImage: new AssetImage('images/avatar.jpg'),
  //         ),
  //         new Padding(
  //           padding: const EdgeInsets.only(left: 16.0),
  //           child: new Column(
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             mainAxisSize: MainAxisSize.min,
  //             children: <Widget>[
  //               new Text(
  //                 'Ryan Barnes',
  //                 style: new TextStyle(
  //                     fontSize: 26.0,
  //                     color: Colors.white,
  //                     fontWeight: FontWeight.w400),
  //               ),
  //               new Text(
  //                 'Product designer',
  //                 style: new TextStyle(
  //                     fontSize: 14.0,
  //                     color: Colors.white,
  //                     fontWeight: FontWeight.w300),
  //               ),
  //             ],
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }