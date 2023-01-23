import 'dart:io';

import 'package:flutter/material.dart';
import 'package:printing/printing.dart';

import '../model/scanned_document.dart';

class DocViewer extends StatelessWidget {
  final ScannedDocument _scannedDocument;

  const DocViewer(this._scannedDocument);

  @override
  Widget build(BuildContext context) {
    final file = File(_scannedDocument.documentUri);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.blue.shade400,
        title: const Text('Document Viewer'),
      ),
      body: PdfPreview(
        build: (_) => file.readAsBytesSync(),
        canChangePageFormat: false,
      ),
    );
  }
}
