import 'package:softel/core/constant/routesstr.dart';
import 'package:softel/core/middleware/mymiddleware.dart';
import 'package:softel/view/screen/auth/company.dart';
import 'package:softel/view/screen/auth/login.dart';
import 'package:softel/view/screen/auth/signup.dart';
import 'package:softel/view/screen/auth/splachscreen.dart';

import 'package:softel/view/screen/cart/cart.dart';
import 'package:softel/view/screen/home/homescreen.dart';
import 'package:softel/view/screen/settings/language.dart';
import 'package:softel/view/screen/famille/famillesdetailes.dart';
import 'package:softel/view/screen/product/productdetails.dart';

import 'package:softel/view/screen/famille/soufamillespage.dart';
import 'package:softel/view/screen/traking/traking.dart';
import 'package:softel/view/screen/home/new_arrivals_page.dart';
import 'package:get/get.dart';
import 'package:softel/view/screen/traking/trakingcartdetaills.dart';

final List<GetPage<dynamic>> routes = [
  // GetPage(name: "", page: () => const Splachscreen()),
  // GetPage(name: AppRoute.language, page: () => Language(), middlewares: [MyMiddleWare()]),
  GetPage(name: "/", page: () => Language(), middlewares: [MyMiddleWare()]),
  GetPage(name: AppRoute.languagechange, page: () => Languagechange()),
  //  Auth
  GetPage(name: AppRoute.splachscreen, page: () => const Splachscreen()),
  GetPage(name: AppRoute.company, page: () => const CompanyPage()),
  GetPage(name: AppRoute.company, page: () => const CompanyPage()),
  // GetPage(name: AppRoute.login, page: () => const Login()),
  // GetPage(name: "/", page: () => const Login()),
  GetPage(name: AppRoute.login, page: () => const Login()),
  GetPage(name: AppRoute.signUp, page: () => const SignUp()),

  //
  GetPage(name: AppRoute.homepage, page: () => const HomeScreen()),
  GetPage(name: AppRoute.homeScreen, page: () => const HomeScreen()),
  GetPage(name: AppRoute.cart, page: () => const Cart()),
  GetPage(name: AppRoute.famillesdetailes, page: () => const Famillesdetailes()),
  GetPage(name: AppRoute.soufamilles, page: () => const Soufamillespage()),
  GetPage(name: AppRoute.productdetails, page: () => const ProductDetails()),
  //
  GetPage(name: AppRoute.trakingdetails, page: () => const TrakingDetails()),
  GetPage(name: AppRoute.trakingcartdetaills, page: () => const Trakingcartdetaills()),
  GetPage(name: AppRoute.newArrivals, page: () => const NewArrivalsPage()),
];
