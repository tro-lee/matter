class People {
  String name;
  String sex;
  int? money;

  People(this.name, this.sex) {}
  People.unOther(String name) : this(name, 'hihi');

  sayHi() {
    print("hi$this.name");
  }
}

main() {
  print("hihi");
  for (var i = 1; i < 100; i++) {
    print(i);
  }
}
