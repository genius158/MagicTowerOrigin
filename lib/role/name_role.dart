
/// 所有类的基类
class Name {
  String type;
  String name;

  Name(this.name);

  Name setName(String name) {
    this.name = name;
    return this;
  }

  Name setType(String type) {
    this.type = type;
    return this;
  }

  @override
  String toString() {
    return super.toString() + name;
  }

  jsonData() {}
}
