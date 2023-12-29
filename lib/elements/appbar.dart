// import 'package:flutter/material.dart';
//
// class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
//   const MyAppBar({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return AppBar(
//       titleSpacing: 10,
//       title: const Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Icon(
//                   Icons.radio,
//                   color: Color.fromARGB(255, 8, 13, 67),
//                   size: 50,
//                 ),
//                 SizedBox(width: 8),
//                 Center(child: Text('CineLyric')),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   @override
//   Size get preferredSize => const Size.fromHeight(kToolbarHeight);
// }

import 'package:flutter/material.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MyAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      titleSpacing: 10,
      title: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.radio,
                  size: 50,
                ),
                SizedBox(width: 8),
                Center(
                    child: Text(
                  'CineLyric',
                  style: TextStyle(),
                )),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
