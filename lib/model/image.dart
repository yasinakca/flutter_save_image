class Photo {
  int id;
  String photoName;

  Photo({this.id, this.photoName});

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map['id'] = this.id;
    map['photoName'] = this.photoName;
    return map;
  }

  Photo.fromMap(Map<String, dynamic> map) {
    this.id = map['id'];
    this.photoName = map['photoName'];
  }
}
