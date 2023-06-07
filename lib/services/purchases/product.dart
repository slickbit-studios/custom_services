enum ConsumptionType {
  permanent,
  consumable,
}

class Product {
  final String id;
  final ConsumptionType type;

  const Product(this.id, this.type);
}
