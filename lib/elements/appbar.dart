import 'package:flutter/material.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MyAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      titleSpacing: 10,
      title: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.radio,
                  color: Theme.of(context).iconTheme.color,
                  size: 50,
                ),
                SizedBox(width: 8),
                Center(
                    child: Text(
                  'CineLyric',
                  style: TextStyle(
                    color: Theme.of(context).iconTheme.color,
                    fontSize: 35,
                  ),
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
