

class Product {
  final String? userId;
  final String? email;
  final String productName;
  final String productPrice;
  final String productDescription;
  final String productQuantity;
  final String productImageUrl;

  Product({
    required this.userId,
    required this.email,
    required this.productName,
    required this.productPrice,
    required this.productDescription,
    required this.productQuantity,
    required this.productImageUrl,
});

  Map<String, dynamic> toMap(){
    return {
      'userId': userId,
      'email': email,
      'productName': productName,
      'productPrice': productPrice,
      'productDescription': productDescription,
      'productQuantity': productQuantity,
      'productImageUrl': productImageUrl,
    };
  }
}