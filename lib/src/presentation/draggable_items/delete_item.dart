import 'package:flutter/material.dart';
import 'package:stories_editor/src/domain/models/editable_items.dart';
import 'package:stories_editor/src/presentation/utils/constants/app_enums.dart';

class DeleteItem extends StatelessWidget {
  const DeleteItem({
    super.key,
    required EditableItem? activeItem,
    required this.isDeletePosition,
    required this.animationsDuration,
    this.deletedItem,
  }) : _activeItem = activeItem;

  final EditableItem? _activeItem;
  final bool isDeletePosition;
  final Duration animationsDuration;
  final Widget? deletedItem;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 40,
      right: 0,
      left: 0,
      child: AnimatedScale(
        curve: Curves.easeIn,
        duration: const Duration(milliseconds: 200),
        scale: _activeItem != null && _activeItem!.type != ItemType.image
            ? 1.0
            : 0.0,
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Center(
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 90,
                  height: 90,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                  child: deletedItem == null
                      ? Transform.scale(
                          scale: 1,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(360),
                            child: deletedItem,
                          ),
                        )
                      : const SizedBox(),
                ),
                AnimatedContainer(
                  alignment: Alignment.center,
                  duration: animationsDuration,
                  height: isDeletePosition ? 55 : 45,
                  width: isDeletePosition ? 55 : 45,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.35),
                    border: Border.all(color: Colors.white),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: const ImageIcon(
                    AssetImage(
                      'assets/icons/trash.png',
                      package: 'stories_editor',
                    ),
                    color: Colors.white,
                    size: 23,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
