import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:insta_assets_picker/insta_assets_picker.dart';
import 'package:love_car/services/services.dart';
import 'package:love_car/src/global/core/core.dart';
import 'package:wechat_camera_picker/wechat_camera_picker.dart';

Future<void> showImagePicker({
  required BuildContext context,
  required AsyncValueChanged<File> onChanged,
}) async {
  final theme = InstaAssetPicker.themeData(Theme.of(context).primaryColor);
  await InstaAssetPicker.pickAssets(
    context,
    maxAssets: 1,
    pickerTheme: theme.copyWith(
      // edit `confirm` button style
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          textStyle: body,
          foregroundColor: Colors.blue,
          disabledForegroundColor: Colors.red,
        ),
      ),
    ),
    textDelegate: EnglishAssetPickerTextDelegate(),
    actionsBuilder: (context, pickerTheme, height, unselectAll) => [
      InstaPickerCircleIconButton(
        size: height,
        theme: pickerTheme,
        icon: const Icon(Icons.camera_alt),
        onTap: () async {
          final asset = await CameraPicker.pickFromCamera(
            context,
            locale: Localizations.maybeLocaleOf(context),
            pickerConfig: CameraPickerConfig(theme: Theme.of(context)),
          );

          final file = await asset?.file;

          if (file == null) return;

          await onChanged(file);
        },
      ),
    ],
    onCompleted: (exportDetails) async {
      exportDetails.listen((event) async {
        final file = event.croppedFiles.firstOrNull;

        if (file == null) return;

        await onChanged(file);
      });

      context.pop();
    },
  );
}
