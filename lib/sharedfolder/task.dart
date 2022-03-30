

class Task {
  String name, priority, description, notes, status, timeAdded, deadline, timeCompleted, imgname;
  late String taskId;
  
  Task(this.name, this.priority, this.description, this.notes, this.status, this.timeAdded, this.deadline, this.timeCompleted, this.imgname);

  static List<Task> parseTasks(tasks) {
    var l = <Task>[];
    Task t;
    tasks.forEach((k, v) => {
      t = Task(v["name"], v["priority"], v["description"], v["notes"], v["status"], v["timeAdded"], v["deadline"], v["timeCompleted"], v["imgname"]),
      t.taskId = k,
      l.add(t),
    });

    return l;
  }

  // used by the calendar widget
  static List<Task> parseTasksCal(tasks, day) {
    var l = <Task>[];
    Task t;
    tasks.forEach((k, v) => {
      if (day.toString().split(" ")[0] == v["timeAdded"].split(" ")[0] || (day == null)){
        t = Task(v["name"], v["priority"], v["description"], v["notes"], v["status"], v["timeAdded"], v["deadline"], v["timeCompleted"], v["imgname"]),
        t.taskId = k,
        l.add(t)
      }
    });
    if (l.isEmpty){
      l = [];
    }
    return l;
  }

}