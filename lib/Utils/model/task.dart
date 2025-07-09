class Task {
  final String title;
  final String description;
  final List<String> steps;
  int progress;
  Set<int> completedSteps;

  Task({
    required this.title,
    required this.description,
    required this.steps,
    this.progress = 0,
    Set<int>? completedSteps,
  }) : completedSteps = completedSteps ?? {};
}
