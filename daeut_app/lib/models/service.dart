class Service {
    int? serviceNo;
    String? serviceCategory;
    String? serviceName;
    int? servicePrice;
    String? serviceContent;
    DateTime? regDate;
    DateTime? updDate;
    int? partnerNo;
    String? thumbnailPath;
    List<String>? filePaths;

    Service ({
      required this.serviceNo,
      required this.serviceCategory,
      required this.serviceName,
      required this.servicePrice,
      required this.serviceContent,
      this.regDate,
      this.updDate,
      required this.partnerNo,
      required this.thumbnailPath,
      required this.filePaths,
    });
}