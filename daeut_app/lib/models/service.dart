class Service {
  final int serviceNo;
  final String serviceName;
  final String serviceCategory;
  final int servicePrice;
  final String serviceContent;
  final int averageRating;
  final List<String> imageUrls;
  final Partner partner;

  Service({
    required this.serviceNo,
    required this.serviceName,
    required this.serviceCategory,
    required this.servicePrice,
    required this.serviceContent,
    required this.averageRating,
    required this.imageUrls,
    required this.partner,
  });

  factory Service.fromJson(Map<String, dynamic> json) {
    return Service(
      serviceNo: json['serviceNo'],
      serviceName: json['serviceName'],
      serviceCategory: json['serviceCategory'],
      servicePrice: json['servicePrice'],
      serviceContent: json['serviceContent'],
      averageRating: json['averageRating'],
      imageUrls: List<String>.from(json['imageUrls']),
      partner: Partner.fromJson(json['partner']),
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
      partnerNo: json['partnerNo'],
      partnerCareer: json['partnerCareer'],
      introduce: json['introduce'],
      userName: json['userName'],
      thumbnailUrl: json['thumbnailUrl'],
    );
  }
}
