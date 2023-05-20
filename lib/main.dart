import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';
import 'screens/onboarding_screen.dart';
import 'screens/registration_screen.dart';
import 'screens/login_screen.dart';
import 'utilities/constants.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/complete_profile_signup.dart';
import 'screens/home_screen.dart';
import 'screens/add_products.dart';
import 'screens/address/address_list_screen.dart';
import 'screens/address/add_address.dart';
import 'screens/address/edit_address.dart';
import 'screens/cart_list_screen.dart';
import 'screens/products/product_details_screen.dart';
import 'screens/checkout/checkout_screen.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData().copyWith(
        inputDecorationTheme: InputDecorationTheme(
          floatingLabelStyle: TextStyle(color: kPrimaryBrandColor)
        )
      ),
      initialRoute: SplashScreen.id,
      routes: {
        SplashScreen.id: (context) => SplashScreen(),
        OnboardingScreen.id: (context) => OnboardingScreen(),
        RegistrationScreen.id: (context) => RegistrationScreen(),
        LoginScreen.id: (context) => LoginScreen(),
        CompleteProfileScreen.id: (context) => CompleteProfileScreen(),
        HomeScreen.id: (context) => HomeScreen(),
        AddProductsScreen.id: (context) => AddProductsScreen(),
        ProductDetailsScreen.id: (context) => ProductDetailsScreen(),
        CartListScreen.id: (context) => CartListScreen(),
        AddressListScreen.id: (context) => AddressListScreen(),
        AddAddress.id: (context) => AddAddress(),
        CheckoutScreen.id: (context) => CheckoutScreen(),
    },);
  }
}

