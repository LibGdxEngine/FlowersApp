import 'package:cloud_firestore/cloud_firestore.dart';

class Item {
  String id;
  final String title;
  final int votes;
  final String image;
  final int price;
  final String category;

  final DocumentReference reference;

  Item({
    this.id,
    this.title,
    this.votes,
    this.image,
    this.reference,
    this.price,
    this.category,
  });

  Item.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['title'] != null),
        assert(map['votes'] != null),
        assert(map['image'] != null),
        assert(map['price'] != null),
        assert(map['id'] != null),
        assert(map['category'] != null),
        title = map['title'],
        image = map['image'],
        votes = map['votes'],
        price = map['price'],
        id = map['id'],
        category = map['category'];

  Item.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  Map<String, dynamic> toMap() => {
        'title': this.title,
        'votes': this.votes,
        'image': this.image,
        'price': this.price,
        'category': this.category,
        'id': this.id,
      };
  @override
  String toString() => "Item<$title:$votes>";
}
