// ignore_for_file: must_be_immutable
library stories_editor;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:stories_editor/src/domain/providers/notifiers/control_provider.dart';
import 'package:stories_editor/src/domain/providers/notifiers/draggable_widget_notifier.dart';
import 'package:stories_editor/src/domain/providers/notifiers/gradient_notifier.dart';
import 'package:stories_editor/src/domain/providers/notifiers/painting_notifier.dart';
import 'package:stories_editor/src/domain/providers/notifiers/scroll_notifier.dart';
import 'package:stories_editor/src/domain/providers/notifiers/text_editing_notifier.dart';
import 'package:stories_editor/src/presentation/main_view/main_view.dart';

export 'package:stories_editor/stories_editor.dart';

class StoriesEditor extends StatefulWidget {
  final List<String>? fontFamilyList;
  final bool? isCustomFontList;
  final Widget? middleBottomWidget;
  final Widget? onDoneButtonStyle;
  final Future<bool>? onBackPress;
  final Color? editorBackgroundColor;
  final void Function() onMusicTap;
  final void Function() onEffectTap;
  final void Function() onDownloadTap;
  final void Function() onFilterDoneTap;
  final void Function() onFilterCancelTap;
  final void Function(String imagePath) onNextButtonTap;
  final Widget videoView;
  final bool isShowFilterIcon;

  const StoriesEditor({
    super.key,
    this.middleBottomWidget,
    this.fontFamilyList,
    this.isCustomFontList,
    this.onBackPress,
    this.onDoneButtonStyle,
    this.editorBackgroundColor,
    required this.onMusicTap,
    required this.onEffectTap,
    required this.onDownloadTap,
    required this.videoView,
    required this.isShowFilterIcon,
    required this.onFilterCancelTap,
    required this.onFilterDoneTap,
    required this.onNextButtonTap,
  });

  @override
  StoriesEditorState createState() => StoriesEditorState();
}

class StoriesEditorState extends State<StoriesEditor> {
  @override
  void initState() {
    // Paint.enableDithering = true;
    WidgetsFlutterBinding.ensureInitialized();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.black,
    ));
    super.initState();
  }

  @override
  void dispose() {
    if (mounted) {
      super.dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<OverscrollIndicatorNotification>(
      onNotification: (overscroll) {
        overscroll.disallowIndicator();
        return false;
      },
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => ControlNotifier()),
          ChangeNotifierProvider(create: (_) => ScrollNotifier()),
          ChangeNotifierProvider(create: (_) => DraggableWidgetNotifier()),
          ChangeNotifierProvider(create: (_) => GradientNotifier()),
          ChangeNotifierProvider(create: (_) => PaintingNotifier()),
          ChangeNotifierProvider(create: (_) => TextEditingNotifier()),
        ],
        child: MainView(
          fontFamilyList: widget.fontFamilyList,
          isCustomFontList: widget.isCustomFontList,
          middleBottomWidget: widget.middleBottomWidget,
          onDoneButtonStyle: widget.onDoneButtonStyle,
          onBackPress: widget.onBackPress,
          editorBackgroundColor: widget.editorBackgroundColor,
          onMusicTap: widget.onMusicTap,
          onEffectTap: widget.onEffectTap,
          onDownloadTap: widget.onDownloadTap,
          onNextButtonTap: widget.onNextButtonTap,
          videoView: widget.videoView,
          isShowFilterIcon: widget.isShowFilterIcon,
          onFilterCancelTap: widget.onFilterCancelTap,
          onFilterDoneTap: widget.onFilterDoneTap,
        ),
      ),
    );
  }
}
