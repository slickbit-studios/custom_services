class _Flavor {
  static const _Flavor local = _Flavor._(name: 'local');
  static const _Flavor beta = _Flavor._(name: 'beta');
  static const _Flavor prod = _Flavor._(name: 'prod');

  static const List<_Flavor> _all = [local, beta, prod];

  final String name;

  const _Flavor._({required this.name});
}

class FlavorConfig {
  static const String _envFlavor = 'app.flavor';

  static FlavorConfig? _instance;

  final _Flavor _flavor;

  FlavorConfig._(this._flavor);

  static FlavorConfig get instance {
    if (_instance == null) {
      _create();
    }
    return _instance!;
  }

  static void _create() {
    for (_Flavor flavor in _Flavor._all) {
      if (_flavorName == flavor.name) {
        _instance = FlavorConfig._(flavor);
        return;
      }
    }

    // default to prod
    _instance = FlavorConfig._(_Flavor.prod);
  }

  static String get _flavorName {
    if (const bool.hasEnvironment(_envFlavor)) {
      return const String.fromEnvironment(_envFlavor);
    }

    throw 'Environment parameter $_envFlavor must be set.';
  }

  bool get isProd => _flavor == _Flavor.prod;

  bool get isBeta => _flavor == _Flavor.beta;

  bool get isLocal => _flavor == _Flavor.local;
}
