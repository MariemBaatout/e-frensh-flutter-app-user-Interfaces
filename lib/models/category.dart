class Category {
  String thumbnail;
  String name;
  String noOfCourses;

  Category({
    required this.name,
    required this.noOfCourses,
    required this.thumbnail,
  });
}

List<Category> categoryList = [
  Category(
    name: 'Bibliothèque de leçon',
    noOfCourses: 'illimité',
    thumbnail: 'asset/images/courses.jpg',
  ),
  Category(
    name: 'Jeux Educatifs',
    noOfCourses: 'illimité',
    thumbnail: 'asset/images/game.jpg',
  ),
  Category(
    name: 'Exercices Applicatifs',
    noOfCourses: 'illimité',
    thumbnail: 'asset/images/exercice.jpg',
  ),
  Category(
    name: 'Quiz',
    noOfCourses: 'illimité',
    thumbnail: 'asset/images/quiz.jpg',
  ),
];
