class SupportHistoryModel {
  final String title;
  final String subtitle;

  SupportHistoryModel({required this.title, required this.subtitle});

  factory SupportHistoryModel.fromJson(Map<String, dynamic> json) {
    return SupportHistoryModel(
      title: json['title'] ?? '',
      subtitle: json['subtitle'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'title': title, 'subtitle': subtitle};
  }
}
