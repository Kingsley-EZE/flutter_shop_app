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
    required this.orderId,
    required this.orderStatus,
  });

  final String userId;
  final List<CartItem> cartItem;
  final Address address;
  final String title;
  final String imageUrl;
  final String totalAmount;
  final String shippingCharge;
  final String orderId;
  final String orderStatus;

  Map<String, dynamic> toMap(){
    return {
      'userId' : userId,
      'cartItem' : cartItem.map((item) => item.toMap()).toList(),
      'address' : address.toMap(),
      'title' : title,
      'imageUrl' : imageUrl,
      'totalAmount' : totalAmount,
      'shippingCharge' : shippingCharge,
      'orderId' : orderId,
      'orderStatus' : orderStatus,
    };
  }

}