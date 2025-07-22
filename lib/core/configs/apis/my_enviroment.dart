class Enviroment {
  static const String PHYSICAL_MACHINE = 'physicalMachine';
  static const String VIRTUAL_MACHINE = 'virtualMachine';

  static const String env = PHYSICAL_MACHINE;

  static bool get isDev => env == VIRTUAL_MACHINE;
  static bool get isProd => env == PHYSICAL_MACHINE;

  static String get baseUrl {
    if (isDev) {
      return 'http://10.0.2.2:8080'; // virtual machine
    }
    return 'http://192.168.1.175:8080'; // physical machine
  }
}