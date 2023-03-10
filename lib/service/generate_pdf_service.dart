// ignore_for_file: deprecated_member_use

import 'dart:io';
import 'dart:typed_data';

import 'package:accounting_portal/service/scanned_document_repository.dart';
import 'package:image/image.dart' as Im;
import 'package:injectable/injectable.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;


@lazySingleton
class GeneratePdfService {
  final ScannedDocumentRepository _scannedDocumentRepository;

  const GeneratePdfService(this._scannedDocumentRepository);

  Future<void> generatePdfFromImages(List<String> imagePaths) async {
    final pdf = pw.Document();

    for (final element in imagePaths) {
      final Im.Image image = Im.decodeImage(await File(element).readAsBytes());
      final Uint8List imageFileBytes = Im.encodeJpg(image, quality: 60);

      pdf.addPage(
        pw.Page(
          build: (pw.Context context) {
            return pw.Center(
              child: pw.Image(
                  PdfImage.file(pdf.document, bytes: imageFileBytes)
              ),
            );
          },
        ),
      );
    }


    await _scannedDocumentRepository.saveScannedDocument(
      firstPageUri: imagePaths.first,
      document: pdf.save(),
    );
  }
}
