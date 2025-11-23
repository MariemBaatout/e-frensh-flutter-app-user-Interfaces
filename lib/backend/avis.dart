class Avis {
  final String avisId;
  final String email;
  final String avis;

  Avis({
    required this.avisId,
    required this.email,
    required this.avis,
  });

  factory Avis.fromJson(Map<String, dynamic> json) {
    return Avis(
      avisId: json['avisId'] as String? ?? '',
      email: json['email'] as String? ?? '',
      avis: json['avis'] as String? ?? '',
    );
  }
}
