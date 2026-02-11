class UserModel {
  final String id;
  final String name;
  final String email;

  UserModel({required this.id, required this.name, required this.email});

  factory UserModel.fromMap(Map<String, dynamic> data , String documentId){
    return UserModel(
      id: documentId,
      name: data['name'] ?? '',
      email: data['email'] ?? '',
    );
  }
  Map<String, dynamic> toMap(){
    return {
      'name': name,
      'email': email,
    };
  }
}