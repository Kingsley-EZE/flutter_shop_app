import 'cartItem.dart';
import 'address.dart';

class Orders{

  Orders({
    required this.userId,
    required this.cartItem,
    required this.address,
    required this.title,
    required this.imageUrl,
    required this.totalAmount,
    required this.shippingCharge,
    required this.orderStatus,
    required this.orderDate,
    required this.productOwnerId,
  });

  final String userId;
  final List<CartItem> cartItem;
  final Address address;
  final String title;
  final String imageUrl;
  final String totalAmount;
  final String shippingCharge;
  final String orderStatus;
  final String orderDate;
  final String productOwnerId;

  Map<String, dynamic> toMap(){
    return {
      'userId' : userId,
      'cartItem' : cartItem.map((item) => item.toMap()).toList(),
      'address' : address.toMap(),
      'title' : title,
      'imageUrl' : imageUrl,
      'totalAmount' : totalAmount,
      'shippingCharge' : shippingCharge,
      'orderStatus' : orderStatus,
      'orderDate' : orderDate,
      'productOwnerId' : productOwnerId,
    };
  }

}