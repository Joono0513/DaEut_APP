class ServiceRequest {
  final String serviceName;
  final int servicePrice;
  final String serviceCategory;
  final String serviceContent;
  final String thumbnailPath;
  final List<String> filePaths;

  ServiceRequest({
    required this.serviceName,
    required this.servicePrice,
    required this.serviceCategory,
    required this.serviceContent,
    required this.thumbnailPath,
    required this.filePaths,
  });

  Map<String, dynamic> toJson() {
    return {
      'serviceName': serviceName,
      'servicePrice': servicePrice,
      'serviceCategory': serviceCategory,
      'serviceContent': serviceContent,
      'thumbnailPath': thumbnailPath,
      'filePaths': filePaths,
    };
  }
}
