class ToDoItem{

  String todo;
  String creator;
  String delegated;
  String id;

  // Constructor

  ToDoItem({this.todo, this.creator, this.delegated, this.id}); // We used named parameters so we can pass stuff in any other

} // End of todoItem
/*
class Users {

  String name;
  String email;
  String household;
  User({this.name, this.email, this.household});
}
*/
class Member {

  String name;

  Member({this.name});
}

class Data {
  ToDoItem text;
  Data({this.text});
}