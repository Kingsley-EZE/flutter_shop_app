

class CartItem {
  String userId;
  String productOwnerId;
  String productId;
  String productName;
  String productPrice;
  String productImageUrl;
  String productCartQuantity;
  String productStockQuantity;

  CartItem({
    this.userId = "",
    this.productOwnerId = "",
    this.productId = "",
    this.productName = "",
    this.productPrice = "",
    this.productImageUrl = "",
    this.productCartQuantity = "",
    this.productStockQuantity = "",
  });

  Map<String, dynamic> toMap(){
    return {
      'userId': userId,
      'productOwnerId': productOwnerId,
      'productId': productId,
      'productName': productName,
      'productPrice': productPrice,
      'productImageUrl': productImageUrl,
      'productCartQuantity': productCartQuantity,
      'productStockQuantity': productStockQuantity,
    };
  }
}
