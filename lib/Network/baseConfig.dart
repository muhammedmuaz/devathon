abstract class BaseConfig {
  String get apiUrl;
  String get baseUrl;
  String get apiUrlClone;
}

class DevConfig implements BaseConfig {
  @override
  String get baseUrl => "http://192.168.18.132:5000";
  @override
  String get apiUrl => "http://192.168.18.132:5000";
  @override
  String get apiUrlClone => "";
}

class ProductionConfig implements BaseConfig {
  @override
  String get baseUrl => "http://192.168.18.132:5000";
  @override
  String get apiUrl => "http://192.168.18.132:5000";
  @override
  String get apiUrlClone => "";
}
//flutter run --dart-define=ENVIRONMENT=dev