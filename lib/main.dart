import 'package:device_preview/device_preview.dart';
import 'package:device_preview/presets.dart';
import 'package:flutter/material.dart';
import 'app.dart';

void main() {
  // Hanya aktif di debug/profile, otomatis mati di build release.
  DevicePreview.enable();
  runApp(const NadyApp());

  // Langsung pakai tampilan iPhone 16 (punya Dynamic Island).
  WidgetsBinding.instance.addPostFrameCallback((_) {
    DevicePreview.maybeController?.applyPreset(DevicePresets.iPhone16);
  });
}