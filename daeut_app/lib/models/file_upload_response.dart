class FileUploadResponse {
  final String filePath;

  FileUploadResponse({required this.filePath});

  factory FileUploadResponse.fromJson(Map<String, dynamic> json) {
    return FileUploadResponse(
      filePath: json['filePath'],
    );
  }
}
