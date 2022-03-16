enum ProductType {
  permanent,
  consumable,
}

class Product {
  final String id;
  final ProductType type;

  const Product(this.id, this.type);
}
