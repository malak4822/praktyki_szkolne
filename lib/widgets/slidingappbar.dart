// import 'package:flutter/material.dart';

// class ScrollingAppBarDemo extends StatefulWidget {
//   const ScrollingAppBarDemo({super.key});

//   @override
//   ScrollingAppBarDemoState createState() => ScrollingAppBarDemoState();
// }

// class ScrollingAppBarDemoState extends State<ScrollingAppBarDemo> {
//   bool _showAppBar = true;
//   final ScrollController _scrollController = ScrollController();

//   @override
//   void initState() {
//     super.initState();
//     _scrollController.addListener(() {
//       if (_scrollController.offset >= kToolbarHeight) {
//         setState(() {
//           _showAppBar = false;
//         });
//       } else {
//         setState(() {
//           _showAppBar = true;
//         });
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return CustomScrollView(
//       controller: _scrollController,
//       slivers: <Widget>[
//         SliverAppBar(
//           pinned: true,
//           floating: true, // Make sure AppBar hides on scroll up
//           snap: true, // Snap back to visible position upon reaching top
//           elevation: 0, // Remove default shadow if desired
//           leading: const Icon(Icons.menu),
//           title: const Text('Title'),
//           actions: const <Widget>[
//             Icon(Icons.search),
//           ],
//           automaticallyImplyLeading:
//               false, // Allow customization of leading icon
              
//           visible:
//               _showAppBar, // Control AppBar visibility based on scroll position
//         ),
//         SliverList(
//           delegate: SliverChildBuilderDelegate(
//             (context, index) {
//               return ListTile(
//                 title: Text('Item $index'),
//               );
//             },
//             childCount: 100, // Adjust as needed
//           ),
//         ),
//       ],
//     );
//   }
// }
