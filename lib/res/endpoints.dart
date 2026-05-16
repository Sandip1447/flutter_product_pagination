class Endpoints {
  const Endpoints._();

  static getProductUrl({int skip = 0, int limit = 10}) =>
      "https://dummyjson.com/products?limit=$limit&skip=$skip";
}
