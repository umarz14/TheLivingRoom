class ToDoItem{

  String todo;
  String creator;
  String delegated;
  String id;
  String hid;

  // Constructor

  ToDoItem({this.todo, this.creator, this.delegated, this.id, this.hid}); // We used named parameters so we can pass stuff in any other

} // End of todoItem

class Member {

  String name;
  String taskId;
  String hid;
  Member({this.name, this.taskId, this.hid});
}

/*
class Data {
  ToDoItem text;
  Data({this.text});
}
*/