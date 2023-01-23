// Future<void> _convertImageToPDF() async {
 
//   //Create the PDF document
//   PdfDocument document = PdfDocument();
 
//   //Add the page
//   PdfPage page = document.pages.add();
 
//   //Load the image
//   final PdfImage image =
//       PdfBitmap(await _readImageData('Autumn Leaves.jpg'));
 
//   //draw image to the first page
//   page.graphics.drawImage(
//       image, Rect.fromLTWH(0, 0, page.size.width, page.size.height));
 
//     //Save the document
//     List<int> bytes = await document.save();
 
//     // Dispose the document
//     document.dispose();
 
//     //Save the file and launch/download
//     SaveFile.saveAndLaunchFile(bytes, 'output.pdf');
//   }