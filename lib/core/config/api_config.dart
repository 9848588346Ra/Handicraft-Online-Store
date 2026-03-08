/// API configuration for connecting to the backend.
///
/// When running on a physical device (tablet/phone), the device must reach
/// your computer's IP. Update [baseUrl] if your computer's IP changes.
///
/// To find your computer's IP:
/// - Windows: run `ipconfig` and look for IPv4 Address
/// - Mac/Linux: run `ifconfig` or `ip addr`
///
/// Requirements:
/// - Backend must be running (npm start in backend folder)
/// - Tablet and computer must be on the SAME WiFi network
/// - Windows Firewall may need to allow Node.js (port 3000)
class ApiConfig {
  /// Base URL for API. Use your computer's IP for physical devices.
  /// Example: 'http://192.168.1.146:3000/api'
  static const String baseUrl = 'http://192.168.1.146:3000/api';

  static const int connectTimeoutSeconds = 15;
  static const int receiveTimeoutSeconds = 15;
}
