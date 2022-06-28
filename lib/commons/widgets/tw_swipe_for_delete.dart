import 'package:flutter/material.dart';
import 'package:flutter_swipe_action_cell/flutter_swipe_action_cell.dart';

class TWSwipeLeftForDeleteTile extends StatelessWidget {
  const TWSwipeLeftForDeleteTile({
    required Key key,
    required this.child,
    required this.deleteAction,
  }) : super(key: key);
  final Function deleteAction;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SwipeActionCell(
      key: key!,
      backgroundColor: Colors.transparent,
      trailingActions: [
        SwipeAction(
          content: const SizedBox(
            width: 46,
            child: Center(
              child: Icon(
                Icons.delete_forever,
                color: Colors.white,
              ),
            ),
          ),
          color: Colors.red,
          onTap: (handler) async {
            await handler(true);
            deleteAction();
          },
        ),
      ],
      child: child,
    );
  }
}
