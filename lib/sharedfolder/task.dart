

class Task {
  String name, priority, description, notes, status, timeAdded, deadline, timeCompleted;

  Task(this.name, this.priority, this.description, this.notes, this.status, this.timeAdded, this.deadline, this.timeCompleted);

  static List<Task> parseTasks(tasks) {
    var l = <Task>[];
    tasks.forEach((k, v) => {
      l.add(Task(v["name"], v["priority"], v["description"], v["notes"], v["status"], v["timeAdded"], v["deadline"], v["timeCompleted"]))
    });

    return l;
  }

  // used by the calendar widget
  static List<Task> parseTasksCal(tasks, day) {
    var l = <Task>[];
    tasks.forEach((k, v) => {
      if (day.toString().split(" ")[0] == v["timeAdded"].split(" ")[0] || (day == null)){
      l.add(Task(v["name"], v["priority"], v["description"], v["notes"], v["status"], v["timeAdded"], v["deadline"], v["timeCompleted"]))}
    });
    if (l.isEmpty){
      l = [];
    }
    return l;
  }

}