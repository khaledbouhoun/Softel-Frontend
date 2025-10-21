class AppLink {
  // static const server = "http://10.104.195.220:8000/api";
  // static const server = "http://192.168.1.74:8000/api";
  static const server = "https://merceriefz.com/softel_api/api";
  static const String tset = "$server/test";
  static const String familleImage = "$server/images/familles/";
  static const String souFamilleImage = "$server/images/soufamilles/";
  static const String articleImage = "$server/images/articles/";
  static const String bannerImage = "$server/images/banner/";

  //========================== Auth ============================
  static const String company = "$server/company";

  static const String login = "$server/login";
  static const String signUp = "$server/signup";
  static const String logout = "$server/logout";
  static const String wilayas = "$server/wilayas";
  static const String communes = "$server/communes";

  //========================== Products ============================
  static const String cartCount = "$server/products/cartCount";

  static const String products = "$server/products";
  static const String imagesBanner = "$server/products/imagesbanner";
  static const String productssearch = "$server/products/search";
  static const String parfamilles = "$server/products/parfamilles";

  //========================== Familles ============================
  static const String familles = "$server/familles";

  //========================== commandes ============================
  static const String commandes = "$server/commandes";
  static const String commandesdetails = "$server/commandes/details";
  static const String storeProduct = "$server/commandes/store";
  static const String cart = "$server/commandes/cart";
  static const String deleteCart = "$server/commandes/deletedetailsbyid";
  static const String confirmCommande = "$server/commandes/confirmcommande";
}
