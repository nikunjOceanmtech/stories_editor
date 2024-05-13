import 'package:flutter/material.dart';
import 'package:stories_editor/src/domain/models/editable_items.dart';
import 'package:stories_editor/src/domain/providers/notifiers/draggable_widget_notifier.dart';
import 'package:stories_editor/src/presentation/utils/constants/app_enums.dart';

Future<dynamic> stickerBottomSheet(
    {required BuildContext context, required DraggableWidgetNotifier editableItem}) async {
  return await showModalBottomSheet(
    context: context,
    backgroundColor: Colors.black45,
    builder: (context) {
      return SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: BottomSheetView(editableItem: editableItem),
      );
    },
  );
}

class BottomSheetView extends StatefulWidget {
  final DraggableWidgetNotifier editableItem;
  const BottomSheetView({super.key, required this.editableItem});

  @override
  State<BottomSheetView> createState() => _BottomSheetViewState();
}

class _BottomSheetViewState extends State<BottomSheetView> {
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
      ),
      itemCount: emojiList.length,
      itemBuilder: (context, index) {
        return InkWell(
          onTap: () {
            Navigator.pop(context);
            widget.editableItem.draggableWidget.add(EditableItem()
              ..type = ItemType.gif
              ..child = Image(
                image: AssetImage(
                  emojiList[index],
                  package: 'stories_editor',
                ),
              )
              ..position = const Offset(0.0, 0.0));
            widget.editableItem.update();
          },
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Image(
              image: AssetImage(
                emojiList[index],
                package: 'stories_editor',
              ),
            ),
          ),
        );
      },
    );
  }
}

List<String> emojiList = [
  "assets/icons/alien.png",
  "assets/icons/smile.png",
  "assets/icons/happy_face.png",
  "assets/icons/emoji.png",
  "assets/icons/cool.png",
  "assets/icons/blackhole.png",
];
