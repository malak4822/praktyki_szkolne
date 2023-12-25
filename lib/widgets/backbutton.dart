import 'package:flutter/material.dart';
import 'package:prakty/constants.dart';
import 'package:prakty/providers/edituser.dart';
import 'package:prakty/providers/googlesign.dart';
import 'package:provider/provider.dart';

Widget backButton(context) => Container(
      width: 52,
      height: 52,
      decoration: const BoxDecoration(
          color: Color.fromARGB(255, 49, 182, 209),
          borderRadius: BorderRadius.only(bottomRight: Radius.circular(50))),
      child: IconButton(
          alignment: Alignment.topLeft,
          iconSize: 28,
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_rounded, color: Colors.white)),
    );

// class HeartWidget extends StatefulWidget {
//   const HeartWidget({super.key, required this.offerId});
//   final String offerId;

//   @override
//   HeartWidgetState createState() => HeartWidgetState();
// }

// class HeartWidgetState extends State<HeartWidget>
//     with SingleTickerProviderStateMixin {
//   late final AnimationController _controller;
//   late final Animation<double> _scaleAnimation;

//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 300),
//     );
//     _scaleAnimation = Tween<double>(begin: 1.0, end: 1.5).animate(
//       CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
//     );
//     _controller.addStatusListener((status) {
//       if (status == AnimationStatus.completed) {
//         _controller.reverse();
//       }
//     });
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   void _toggleLike() {
//     _controller.forward();
//   }

//   @override
//   Widget build(BuildContext context) {
//     bool isLiked =
//         Provider.of<GoogleSignInProvider>(context, listen: false).isLiked;
//     return Container(
//         width: 52,
//         height: 52,
//         decoration: BoxDecoration(
//             color: gradient[1],
//             borderRadius:
//                 const BorderRadius.only(bottomLeft: Radius.circular(50))),
//         child: GestureDetector(
//           onTap: () {
//             _toggleLike();
//             Provider.of<GoogleSignInProvider>(context, listen: false)
//                 .toogleOffer('');
//           },
//           child: AnimatedBuilder(
//             animation: _scaleAnimation,
//             builder: (context, child) {
//               return Transform.scale(
//                 scale: _scaleAnimation.value,
//                 child: child,
//               );
//             },
//             child: Icon(
//               isLiked ? Icons.favorite : Icons.favorite_border,
//               color: isLiked ? Colors.red : Colors.white,
//               size: 34,
//             ),
//           ),
//         ));
//   }
// }
