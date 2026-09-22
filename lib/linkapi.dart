class AppLink {
  static const String tset = "$server/test";
  static const domine = "https://b2b.softel.dz";

  // Images URLs
  static const images = "$domine/images";
  static const articlesimages = "$images/articles/";
  static const famillesimages = "$images/familles/";
  static const bannersimages = "$images/banners/";
  static const softelClientImages = "$images/clients_softel/";

  //  ============================================= Server =====================================================
  static const server = "$domine/api";

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
