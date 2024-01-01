class FriendModal {
  String firstName;
  String lastName;
  String email;
  String profilePic;

  FriendModal({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.profilePic,
  });

  factory FriendModal.fromMap({required Map data}) {
    return FriendModal(
      firstName: data['firstName'],
      lastName: data['lastName'],
      email: data['email'],
      profilePic: data['profilePic'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'profilePic': profilePic,
    };
  }
}
