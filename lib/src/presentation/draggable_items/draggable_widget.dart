import 'dart:io';

import 'package:align_positioned/align_positioned.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stories_editor/src/domain/models/editable_items.dart';
import 'package:stories_editor/src/domain/providers/notifiers/control_provider.dart';
import 'package:stories_editor/src/domain/providers/notifiers/draggable_widget_notifier.dart';
import 'package:stories_editor/src/domain/providers/notifiers/gradient_notifier.dart';
import 'package:stories_editor/src/domain/providers/notifiers/text_editing_notifier.dart';
import 'package:stories_editor/src/presentation/utils/constants/app_enums.dart';
import 'package:stories_editor/src/presentation/widgets/animated_onTap_button.dart';
import 'package:stories_editor/src/presentation/widgets/file_image_bg.dart';

class DraggableWidget extends StatelessWidget {
  final EditableItem draggableWidget;
  final Function(PointerDownEvent)? onPointerDown;
  final Function(PointerUpEvent)? onPointerUp;
  final Function(PointerMoveEvent)? onPointerMove;
  final BuildContext context;
  const DraggableWidget({
    super.key,
    required this.context,
    required this.draggableWidget,
    this.onPointerDown,
    this.onPointerUp,
    this.onPointerMove,
  });

  @override
  Widget build(BuildContext context) {
    var colorProvider = Provider.of<GradientNotifier>(this.context, listen: false);
    var controlProvider = Provider.of<ControlNotifier>(this.context, listen: false);
    Widget? overlayWidget;

    if (draggableWidget.type == ItemType.text) {
      overlayWidget = IntrinsicWidth(
        child: IntrinsicHeight(
          child: Container(
            constraints: BoxConstraints(
              minHeight: 50,
              minWidth: 50,
              maxWidth: MediaQuery.of(context).size.width - 240,
            ),
            width: draggableWidget.deletePosition ? 100 : null,
            height: draggableWidget.deletePosition ? 100 : null,
            child: AnimatedOnTapButton(
              onTap: () => _onTap(context, draggableWidget, controlProvider),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Center(
                    child: _text(
                      background: true,
                      paintingStyle: PaintingStyle.fill,
                      controlNotifier: controlProvider,
                    ),
                  ),
                  IgnorePointer(
                    ignoring: true,
                    child: Center(
                      child: _text(
                        background: true,
                        paintingStyle: PaintingStyle.stroke,
                        controlNotifier: controlProvider,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 2.5, top: 2),
                    child: Stack(
                      children: [
                        Center(
                          child: _text(paintingStyle: PaintingStyle.fill, controlNotifier: controlProvider),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      );
    } else if (draggableWidget.type == ItemType.image) {
      overlayWidget = const SizedBox.shrink();
    } else if (draggableWidget.type case ItemType.gif) {
      overlayWidget = FileImageBG(
        filePath: File(""),
        generatedGradient: (color1, color2) {
          colorProvider.color1 = color1;
          colorProvider.color2 = color2;
        },
        child: draggableWidget.child!,
      );
    } else if (draggableWidget.type == ItemType.video) {
      overlayWidget = const Center();
    }

    return AnimatedAlignPositioned(
      duration: const Duration(milliseconds: 50),
      dy: (draggableWidget.deletePosition
          ? _deleteTopOffset()
          : (draggableWidget.position.dy * MediaQuery.of(context).size.height)),
      dx: (draggableWidget.deletePosition ? 0 : (draggableWidget.position.dx * MediaQuery.of(context).size.width)),
      alignment: Alignment.center,
      child: Transform.scale(
        scale: draggableWidget.deletePosition ? _deleteScale() : draggableWidget.scale,
        child: Transform.rotate(
          angle: draggableWidget.rotation,
          child: Listener(
            onPointerDown: onPointerDown,
            onPointerUp: onPointerUp,
            onPointerMove: onPointerMove,
            child: overlayWidget,
          ),
        ),
      ),
    );
  }

  /// text widget
  Widget _text(
      {required ControlNotifier controlNotifier, required PaintingStyle paintingStyle, bool background = false}) {
    if (draggableWidget.animationType == TextAnimationType.none) {
      return Text(draggableWidget.text,
          textAlign: draggableWidget.textAlign,
          style: _textStyle(controlNotifier: controlNotifier, paintingStyle: paintingStyle, background: background));
    } else {
      return DefaultTextStyle(
        style: _textStyle(controlNotifier: controlNotifier, paintingStyle: paintingStyle, background: background),
        child: AnimatedTextKit(
          repeatForever: true,
          onTap: () => _onTap(context, draggableWidget, controlNotifier),
          animatedTexts: [
            if (draggableWidget.animationType == TextAnimationType.scale)
              ScaleAnimatedText(draggableWidget.text, duration: const Duration(milliseconds: 1200)),
            if (draggableWidget.animationType == TextAnimationType.fade)
              ...draggableWidget.textList
                  .map((item) => FadeAnimatedText(item, duration: const Duration(milliseconds: 1200))),
            if (draggableWidget.animationType == TextAnimationType.typer)
              TyperAnimatedText(draggableWidget.text, speed: const Duration(milliseconds: 500)),
            if (draggableWidget.animationType == TextAnimationType.typeWriter)
              TypewriterAnimatedText(
                draggableWidget.text,
                speed: const Duration(milliseconds: 500),
              ),
            if (draggableWidget.animationType == TextAnimationType.wavy)
              WavyAnimatedText(
                draggableWidget.text,
                speed: const Duration(milliseconds: 500),
              ),
            if (draggableWidget.animationType == TextAnimationType.flicker)
              FlickerAnimatedText(
                draggableWidget.text,
                speed: const Duration(milliseconds: 1200),
              ),
          ],
        ),
      );
    }
  }

  _textStyle(
      {required ControlNotifier controlNotifier, required PaintingStyle paintingStyle, bool background = false}) {
    return TextStyle(
      fontFamily: controlNotifier.fontList![draggableWidget.fontFamily],
      package: controlNotifier.isCustomFontList ? null : 'stories_editor',
      fontWeight: FontWeight.w500,
      // shadows: <Shadow>[
      //   Shadow(
      //       offset: const Offset(0, 0),
      //       //blurRadius: 3.0,
      //       color: draggableWidget.textColor == Colors.black
      //           ? Colors.white54
      //           : Colors.black)
      // ]
    ).copyWith(
        color: background ? Colors.black : draggableWidget.textColor,
        fontSize: draggableWidget.deletePosition ? 8 : draggableWidget.fontSize,
        background: Paint()
          ..strokeWidth = 20.0
          ..color = draggableWidget.backGroundColor
          ..style = paintingStyle
          ..strokeJoin = StrokeJoin.round
          ..filterQuality = FilterQuality.high
          ..strokeCap = StrokeCap.round
          ..maskFilter = const MaskFilter.blur(BlurStyle.solid, 1));
  }

  _deleteTopOffset() {
    double top = 0.0;
    if (draggableWidget.type == ItemType.text) {
      top = MediaQuery.of(context).size.width / 1.2;
      return top;
    } else if (draggableWidget.type == ItemType.gif) {
      top = MediaQuery.of(context).size.width / 1.18;
      return top;
    }
  }

  _deleteScale() {
    double scale = 0.0;
    if (draggableWidget.type == ItemType.text) {
      scale = 0.4;
      return scale;
    } else if (draggableWidget.type == ItemType.gif) {
      scale = 0.3;
      return scale;
    }
  }

  /// onTap text
  void _onTap(BuildContext context, EditableItem item, ControlNotifier controlNotifier) {
    var editorProvider = Provider.of<TextEditingNotifier>(this.context, listen: false);
    var itemProvider = Provider.of<DraggableWidgetNotifier>(this.context, listen: false);

    /// load text attributes
    editorProvider.textController.text = item.text.trim();
    editorProvider.text = item.text.trim();
    editorProvider.fontFamilyIndex = item.fontFamily;
    editorProvider.textSize = item.fontSize;
    editorProvider.backGroundColor = item.backGroundColor;
    editorProvider.textAlign = item.textAlign;
    editorProvider.textColor = controlNotifier.colorList!.indexOf(item.textColor);
    editorProvider.animationType = item.animationType;
    editorProvider.textList = item.textList;
    editorProvider.fontAnimationIndex = item.fontAnimationIndex;
    itemProvider.draggableWidget.removeAt(itemProvider.draggableWidget.indexOf(item));
    editorProvider.fontFamilyController = PageController(
      initialPage: item.fontFamily,
      viewportFraction: .1,
    );

    /// create new text item
    controlNotifier.isTextEditing = !controlNotifier.isTextEditing;
  }
}
