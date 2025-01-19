class Employee {
  String? name;
  String? addingDate;

  Employee({this.addingDate, this.name});
  Employee.fromJson(dynamic data) {
    name = data['Name'];
    addingDate = data['AddingDate'];
  }
  get toMap {
    return {
      'Name': name,
      'AddingDate': addingDate,
    };
  }
}
