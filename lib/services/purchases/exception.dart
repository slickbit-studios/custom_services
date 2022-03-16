class PurchaseException {
  final int code;
  final String message;

  static const NOT_REACHABLE = 0;
  static const NOT_FOUND = 1;

  PurchaseException.notReachable()
      : message = 'Failed to access store to buy product',
        code = NOT_REACHABLE;

  PurchaseException.notFound(String id)
      : message = 'Product with id $id not found in store',
        code = NOT_FOUND;
}
