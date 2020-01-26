import 'package:cloud_firestore/cloud_firestore.dart';

class Order {
  String id;
  final String name;
  final String location;
  final String notes;
  final String phone;
  final DocumentReference reference;
  final List<String> ordersItemsIDs;
  final DateTime time = DateTime.now();

  Order({
    this.id,
    this.name,
    this.location,
    this.reference,
    this.notes,
    this.phone,
    this.ordersItemsIDs,
  });

  Order.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['name'] != null),
        assert(map['votes'] != null),
        assert(map['location'] != null),
        assert(map['id'] != null),
        assert(map['phone'] != null),
        assert(map['ordersItemsIDs'] != null),
        assert(map['time'] != null),
        name = map['name'],
        location = map['location'],
        notes = map['notes'],
        id = map['id'],
        phone = map['phone'],
        ordersItemsIDs = map['ordersItemsIDs'];

  Order.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  Map<String, dynamic> toMap() => {
        'name': this.name,
        'location': this.location,
        'notes': this.notes,
        'phone': this.phone,
        'id': this.id,
        'ordersItemsIDs': this.ordersItemsIDs,
        'time': this.time,
      };
  @override
  String toString() => "Item<$name:$location>";
}
