
class Address{
  String name;
  String phoneNumber;
  String address;
  String city;
  String additionalNote;
  String userId;

  Address({
   this.name = '',
   this.phoneNumber = '',
   this.address = '',
   this.city = '',
   this.additionalNote = '',
   this.userId = '',
  });

  Map<String, dynamic> toMap(){
    return {
      'name' : name,
      'phoneNumber' : phoneNumber,
      'address' : address,
      'city' : city,
      'additionalNote' : additionalNote,
      'userId' : userId,
    };
  }

}