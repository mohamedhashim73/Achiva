class FriendModel {
  late String id;
  late bool status;

  FriendModel({required this.id, required this.status,});

  factory FriendModel.fromJson({required Map<String,dynamic> json})=> FriendModel(id: json['id'],status: json['status']);

  Map<String,dynamic> toJson()=> {
    "id" : id,
    "status" : status
  };
}