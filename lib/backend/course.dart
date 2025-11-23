class Course {
  final String courseId;
  final String email;
  final String name;
  final String image;
  final String videoLink;
  final String playlistLink;
  final String type;
  final String description;
  final bool completed; // Corrected boolean type

  Course({
    required this.courseId,
    required this.email,
    required this.name,
    required this.image,
    required this.videoLink,
    required this.playlistLink,
    required this.type,
    required this.description,
    required this.completed, // Added completed to the constructor
  });

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      courseId: json['courseId'] as String? ?? '',
      email: json['email'] as String? ?? '',
      name: json['name'] as String? ?? '',
      image: json['image'] as String? ?? '',
      videoLink: json['videoLink'] as String? ?? '',
      playlistLink: json['playlistLink'] as String? ?? '',
      type: json['type'] as String? ?? '',
      description: json['description'] as String? ?? '',
      completed: json['completed'] == null
          ? false
          : json['completed'] as bool, // Handle boolean conversion
    );
  }
}
