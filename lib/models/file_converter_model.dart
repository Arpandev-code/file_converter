class FileConverterModel {
  final String inputPath;
  final String outputPath;
  final String inputFormat;
  final String outputFormat;

  FileConverterModel({
    required this.inputPath,
    required this.outputPath,
    required this.inputFormat,
    required this.outputFormat,
  });

  Map<String, dynamic> toJson() {
    return {
      'inputPath': inputPath,
      'outputPath': outputPath,
      'inputFormat': inputFormat,
      'outputFormat': outputFormat,
    };
  }

  factory FileConverterModel.fromJson(Map<String, dynamic> json) {
    return FileConverterModel(
      inputPath: json['inputPath'],
      outputPath: json['outputPath'],
      inputFormat: json['inputFormat'],
      outputFormat: json['outputFormat'],
    );
  }
}
