import 'dart:typed_data';

import 'package:flutter/widgets.dart';

import '../model/scanned_document.dart';

abstract class ScannedDocumentRepository {
  Future<List<ScannedDocument>> getAll();
  Future<void> saveScannedDocument({
    @required String firstPageUri,
    @required Uint8List document,
  });
}
