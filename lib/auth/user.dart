class UserModel {
  final String id, name, email, role;
  UserModel({required this.id,required this.name,required this.email,required this.role});
  factory UserModel.fromJson(Map<String,dynamic> j)=>UserModel(
    id:j['id']??j['_id'], name:j['name'], email:j['email'], role:j['role']);
}