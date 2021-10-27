class Category {
  int id;
  String name;
  String descrption;

  categoryMap() {
    var mapping = <String, dynamic>{};
    mapping['id'] = id;
    mapping['name'] = name;
    mapping['descrption'] = descrption;

    return mapping;
  }
}
