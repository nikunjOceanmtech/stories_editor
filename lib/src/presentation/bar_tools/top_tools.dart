import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stories_editor/src/domain/providers/notifiers/control_provider.dart';
import 'package:stories_editor/src/domain/providers/notifiers/draggable_widget_notifier.dart';
import 'package:stories_editor/src/domain/providers/notifiers/painting_notifier.dart';
import 'package:stories_editor/src/sticker_bottom_sheet.dart';

class TopTools extends StatefulWidget {
  final GlobalKey contentKey;
  final BuildContext context;
  final void Function() onMusicTap;
  final void Function() onEffectTap;
  final void Function() onDownloadTap;
  final void Function() onFilterDoneTap;
  final void Function() onFilterCancelTap;
  final bool isShowFilterIcon;

  const TopTools({
    super.key,
    required this.contentKey,
    required this.context,
    required this.onMusicTap,
    required this.onEffectTap,
    required this.onDownloadTap,
    required this.isShowFilterIcon,
    required this.onFilterCancelTap,
    required this.onFilterDoneTap,
  });

  @override
  TopToolsState createState() => TopToolsState();
}

class TopToolsState extends State<TopTools> {
  @override
  Widget build(BuildContext context) {
    return Consumer3<ControlNotifier, PaintingNotifier, DraggableWidgetNotifier>(
      builder: (_, controlNotifier, paintingNotifier, itemNotifier, __) {
        return SafeArea(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            decoration: const BoxDecoration(color: Colors.transparent),
            child: widget.isShowFilterIcon
                ? filterIconView(context: context)
                : normalIconView(
                    context: context,
                    controlNotifier: controlNotifier,
                    itemNotifier: itemNotifier,
                  ),
          ),
        );
      },
    );
  }

  Widget filterIconView({required BuildContext context}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // TODO: change to cross and done icon
        commonIconView(
          imageUrl: "assets/icons/back_arrow.png",
          onTap: widget.onFilterCancelTap,
        ),
        commonIconView(
          imageUrl: "assets/icons/back_arrow.png",
          onTap: widget.onFilterDoneTap,
        ),
      ],
    );
  }

  Widget normalIconView({
    required ControlNotifier controlNotifier,
    required BuildContext context,
    required DraggableWidgetNotifier itemNotifier,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        commonIconView(
          imageUrl: "assets/icons/back_arrow.png",
          onTap: () => Navigator.pop(context),
        ),
        Row(
          children: [
            commonIconView(
              imageUrl: "assets/icons/music.png",
              onTap: widget.onMusicTap,
            ),
            const SizedBox(width: 10),
            commonIconView(
              imageUrl: "assets/icons/text.png",
              onTap: () => controlNotifier.isTextEditing = !controlNotifier.isTextEditing,
            ),
            const SizedBox(width: 10),
            commonIconView(
              imageUrl: "assets/icons/stickers.png",
              onTap: () async {
                await stickerBottomSheet(
                  context: context,
                  editableItem: itemNotifier,
                );
                // await createGiphyItem(context: context);
              },
            ),
            const SizedBox(width: 10),
            commonIconView(
              imageUrl: "assets/icons/effect.png",
              onTap: widget.onEffectTap,
            ),
            const SizedBox(width: 10),
            commonIconView(
              imageUrl: "assets/icons/download.png",
              onTap: widget.onDownloadTap,
            ),
          ],
        ),
      ],
    );
  }

  Widget commonIconView({
    required String imageUrl,
    required void Function() onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Image(
        image: AssetImage(imageUrl, package: 'stories_editor'),
        height: 45,
        width: 45,
      ),
    );
  }
}
