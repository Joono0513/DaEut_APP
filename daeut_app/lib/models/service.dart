class Service {
  final int serviceNo;
  final String serviceName;
  final String serviceCategory;
  final int servicePrice;
  final String serviceContent;
  final double averageRating;
  final List<String> imageUrls;
  final Partner partner;
  final String userName;
  final int fileNo;

  Service({
    required this.serviceNo,
    required this.serviceName,
    required this.serviceCategory,
    required this.servicePrice,
    required this.serviceContent,
    required this.averageRating,
    required this.imageUrls,
    required this.partner,
    required this.userName,
    required this.fileNo,
  });

  factory Service.fromJson(Map<String, dynamic> json) {
    return Service(
      serviceNo: json['serviceNo'] ?? 0,
      serviceName: json['serviceName'] ?? 'Unknown',
      serviceCategory: json['serviceCategory'] ?? 'Unknown',
      servicePrice: (json['servicePrice'] ?? 0).toInt(),
      serviceContent: json['serviceContent'] ?? '',
      averageRating: (json['averageRating'] ?? 0).toDouble(),
      imageUrls: (json['imageUrls'] as List<dynamic>?)
              ?.map((item) => item as String)
              .toList() ?? [],
      partner: Partner.fromJson(json['partner'] ?? <String, dynamic>{}),
      userName: json['userName'] ?? 'Unknown',
      fileNo: (json['fileNo'] ?? 0).toInt(),
    );
  }
}

class Partner {
  final int partnerNo;
  final String partnerCareer;
  final String introduce;
  final String userName;
  final String thumbnailUrl;

  Partner({
    required this.partnerNo,
    required this.partnerCareer,
    required this.introduce,
    required this.userName,
    required this.thumbnailUrl,
  });

  factory Partner.fromJson(Map<String, dynamic> json) {
    return Partner(
      partnerNo: json['partnerNo'] ?? 0,
      partnerCareer: json['partnerCareer'] ?? '',
      introduce: json['introduce'] ?? '',
      userName: json['userName'] ?? '',
      thumbnailUrl: json['thumbnailUrl'] ?? '',
    );
  }
}
