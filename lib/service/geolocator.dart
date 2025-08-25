import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';
import 'dart:io';

Future<bool> ensureLocationReady(BuildContext context) async {
  // 1) Servis açık mı?
  final serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    // Kullanıcıyı ayara yönlendir
    await Geolocator.openLocationSettings();
    return false;
  }

  // 2) İzin durumu
  LocationPermission perm = await Geolocator.checkPermission();

  if (perm == LocationPermission.denied) {
    perm = await Geolocator.requestPermission();
  }

  if (perm == LocationPermission.deniedForever) {
    // Ayarlara yönlendir; kullanıcı elle açmak zorunda
    await Geolocator.openAppSettings();
    return false;
  }

  // Android 12+ için “Precise location” kapalıysa yüksek doğruluk alamazsın,
  // ama stream yine de çalışır. (Gerekirse kullanıcıya bilgilendirme ver.)
  return perm == LocationPermission.whileInUse ||
        perm == LocationPermission.always;
}
