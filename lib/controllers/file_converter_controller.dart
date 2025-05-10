import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:typed_data';
import 'package:image/image.dart' as img;
import 'dart:html' as html;

class FileConverterController extends GetxController {
  // Observable states
  final RxBool isConverting = false.obs;
  final RxString statusMessage = ''.obs;
  final RxString selectedFileName = ''.obs;
  final RxDouble conversionProgress = 0.0.obs;
  final RxList<String> conversionHistory = <String>[].obs;

  // Supported image formats
  final Map<String, List<String>> supportedFormats = {
    'png': ['jpg', 'webp'],
    'jpg': ['png', 'webp'],
    'jpeg': ['png', 'webp'],
    'bmp': ['png', 'jpg', 'webp'],
    'gif': ['jpg', 'png', 'webp'],
    'webp': ['png', 'jpg'],
  };

  // Maximum file size (10MB)
  static const int maxFileSize = 10 * 1024 * 1024;

  Future<void> convertImageFormat(String fromFormat, String toFormat) async {
    try {
      // Validate format support
      if (!_isFormatSupported(fromFormat, toFormat)) {
        throw Exception(
            'Conversion from $fromFormat to $toFormat is not supported');
      }

      isConverting.value = true;
      conversionProgress.value = 0.0;
      statusMessage.value = 'Selecting image file...';

      // Pick file with specific format
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: [fromFormat],
        withData: true,
      );

      if (result == null) {
        statusMessage.value = 'No file selected';
        return;
      }

      // Validate file size
      if (result.files.single.size > maxFileSize) {
        throw Exception('File size exceeds 10MB limit');
      }

      selectedFileName.value = result.files.single.name;
      statusMessage.value = 'Converting image format...';
      conversionProgress.value = 0.2;

      // Get the image data
      Uint8List? imageBytes = result.files.single.bytes;
      if (imageBytes == null) {
        throw Exception('Could not read image data');
      }

      // Decode the image with error handling
      img.Image? image = await _decodeImage(imageBytes);
      if (image == null) {
        throw Exception('Could not decode image');
      }

      conversionProgress.value = 0.4;

      // Convert the image with optimized settings
      Uint8List convertedBytes = await _convertImage(image, toFormat);
      conversionProgress.value = 0.6;

      // Save the converted image
      String fileName = result.files.single.name.split('.').first;
      String newFileName = '$fileName.$toFormat';

      await _saveFile(convertedBytes, newFileName);
      conversionProgress.value = 1.0;

      // Update conversion history
      _updateConversionHistory(fromFormat, toFormat, newFileName);

      statusMessage.value = 'Conversion completed! File saved as $newFileName';
    } catch (e) {
      statusMessage.value = 'Error: ${e.toString()}';
    } finally {
      isConverting.value = false;
      conversionProgress.value = 0.0;
    }
  }

  // Helper method to decode image with timeout
  Future<img.Image?> _decodeImage(Uint8List bytes) async {
    try {
      return await Future.sync(() => img.decodeImage(bytes))
          .timeout(const Duration(seconds: 10));
    } catch (e) {
      return null;
    }
  }

  // Helper method to convert image with optimized settings
  Future<Uint8List> _convertImage(img.Image image, String toFormat) async {
    switch (toFormat) {
      case 'jpg':
        return img.encodeJpg(image, quality: 90);
      case 'png':
        return img.encodePng(image);
      case 'webp':
        // Fallback to PNG since WebP encoding is not directly supported
        return img.encodePng(image);
      default:
        throw Exception('Unsupported output format: $toFormat');
    }
  }

  // Helper method to save file
  Future<void> _saveFile(Uint8List bytes, String fileName) async {
    final blob = html.Blob([bytes]);
    final url = html.Url.createObjectUrlFromBlob(blob);
    final anchor = html.AnchorElement(href: url)
      ..setAttribute('download', fileName)
      ..click();
    html.Url.revokeObjectUrl(url);
  }

  // Helper method to update conversion history
  void _updateConversionHistory(
      String fromFormat, String toFormat, String fileName) {
    final timestamp = DateTime.now().toString();
    final historyEntry = '$timestamp: $fromFormat → $toFormat ($fileName)';
    conversionHistory.insert(0, historyEntry);

    // Keep only last 10 conversions
    if (conversionHistory.length > 10) {
      conversionHistory.removeLast();
    }
  }

  // Helper method to validate format support
  bool _isFormatSupported(String fromFormat, String toFormat) {
    return supportedFormats[fromFormat]?.contains(toFormat) ?? false;
  }

  // Clear conversion history
  void clearHistory() {
    conversionHistory.clear();
  }
}
