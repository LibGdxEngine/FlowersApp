import 'package:cloud_firestore/cloud_firestore.dart';

class Record {
  final String title;
  final int votes;
  final String image;
  final DocumentReference reference;

  Record({this.title, this.votes, this.image, this.reference});

  Record.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['title'] != null),
        assert(map['votes'] != null),
        assert(map['image'] != null),
        title = map['title'],
        image = map['image'],
        votes = map['votes'];

  Record.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  Map<String, dynamic> toMap() => {
        'title': this.title,
        'votes': this.votes,
        'image': this.image,
      };
  @override
  String toString() => "Record<$title:$votes>";
}
