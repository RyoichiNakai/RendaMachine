class User {
  int _id;
  String _username;
  int _score;

  User(this._id, this._username, this._score) ;

  User.map(dynamic obj) {
    this._id = obj['id'];
    this._username = obj['username'];
    this._score = obj['score'];
  }

  int get id => _id;
  String get username => _username;
  int get score => _score;

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map["id"] = _id;
    map["username"] = _username;
    map["score"] = _score;
    return map;
  }
}