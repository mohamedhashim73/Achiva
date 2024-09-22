// User Model


// Friend Model
class Friend {
  String friendsUsername;
  String status;

  Friend({required this.friendsUsername, required this.status});
}

// Task Model
class Task {
  int id;
  String name;
  String description;
  String location;
  String date;
  String time;
  int duration;
  String status;
  RepeatingTask? repeatingTask;
  Post? post;
  List<Reaction> reactions;

  Task({
    required this.id,
    required this.name,
    required this.description,
    required this.location,
    required this.date,
    required this.time,
    required this.duration,
    required this.status,
    this.repeatingTask,
    this.post,
    required this.reactions,
  });
}

// Repeating Task Model
class RepeatingTask {
  int mainTaskId;
  String frequency;
  List<RelatedTask> relatedTasks;

  RepeatingTask({
    required this.mainTaskId,
    required this.frequency,
    required this.relatedTasks,
  });
}

// Related Task Model
class RelatedTask {
  int taskId;
  String date;
  String status;

  RelatedTask({
    required this.taskId,
    required this.date,
    required this.status,
  });
}

// Post Model
class Post {
  int taskId;
  String photo;
  int noReaction;
  String postDate;

  Post({
    required this.taskId,
    required this.photo,
    required this.noReaction,
    required this.postDate,
  });
}

// Reaction Model
class Reaction {
  String friendsUsername;
  String emoji;

  Reaction({
    required this.friendsUsername,
    required this.emoji,
  });
}
