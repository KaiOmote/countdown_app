// lib/core/utils/share_utils.dart
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class ShareUtils {
  static Future<bool> shareBoundaryAsImage({
    required GlobalKey key,
    String fileName = 'countdown_share.png',
    String? subject,
    Duration menuDismissDelay = const Duration(milliseconds: 120),
    ui.Color? backgroundColor,
    double pixelRatioMultiplier = 2.0,
  }) async {
    try {
      if (menuDismissDelay > Duration.zero) {
        await Future.delayed(menuDismissDelay);
      }

      final ctx = key.currentContext;
      if (ctx == null) return false;

      // Give layout/paint a moment, then ensure a full frame completed.
      await Future.delayed(const Duration(milliseconds: 16));
      await WidgetsBinding.instance.endOfFrame;

      final ro = ctx.findRenderObject();
      if (ro is! RenderRepaintBoundary) return false;

      // If it still needs paint, wait another frame.
      if (ro.debugNeedsPaint) {
        await Future.delayed(const Duration(milliseconds: 16));
        await WidgetsBinding.instance.endOfFrame;
      }

      final dpr = View.maybeOf(ctx)?.devicePixelRatio ?? 2.0;
      final pixelRatio = (dpr * pixelRatioMultiplier).clamp(1.0, 4.0);

      final ui.Image raw = await ro.toImage(pixelRatio: pixelRatio);

      final ui.Image img = backgroundColor == null
          ? raw
          : await _compositeBackground(raw, backgroundColor);

      final byteData = await img.toByteData(format: ui.ImageByteFormat.png);
      if (byteData == null) return false;

      final bytes = byteData.buffer.asUint8List();
      final dir = await getTemporaryDirectory();
      final file = File('${dir.path}/$fileName');
      await file.writeAsBytes(bytes, flush: true);

      await Share.shareXFiles([XFile(file.path)], subject: subject);
      return true;
    } catch (_) {
      return false;
    }
  }

  static Future<ui.Image> _compositeBackground(ui.Image src, ui.Color bg) async {
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(
      recorder,
      Rect.fromLTWH(0, 0, src.width.toDouble(), src.height.toDouble()),
    );
    canvas.drawRect(
      Rect.fromLTWH(0, 0, src.width.toDouble(), src.height.toDouble()),
      Paint()..color = bg,
    );
    canvas.drawImage(src, Offset.zero, Paint());
    final pic = recorder.endRecording();
    return pic.toImage(src.width, src.height);
  }
}
