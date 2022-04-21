import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';
import 'package:flutter/material.dart';
import 'package:piyasaekrani/core/widgets/core_widget.dart';

class PdfReader extends StatefulWidget {
  const PdfReader({
    Key? key,
    required this.url,
  }) : super(key: key);

  final String url;
  @override
  State<PdfReader> createState() => _PdfReaderState();
}

class _PdfReaderState extends State<PdfReader> {
  bool _isLoading = true;
  late PDFDocument document;
  @override
  void initState() {
    super.initState();
    loadDocument();
  }

  loadDocument() async {
    document = await PDFDocument.fromURL(widget.url);

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    var x65Height = context.dynamicHeight(0.65);
    return Container(
      constraints: BoxConstraints(minHeight: 1, minWidth: double.infinity, maxHeight: x65Height),
      child: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : PDFViewer(
              document: document,
              zoomSteps: 1,
            ),
    );
  }
}
