class Config {
  // Backend Server (Puerto 3000)
  // Maneja tanto REST API como Socket.IO en el mismo servidor
  static const String backendUrl = 'https://h0jpg5qd-3000.use2.devtunnels.ms';
  
  // LiveKit Server URL (Puerto 7880)
  // URL fija del servidor LiveKit - no viene del backend
  static const String liveKitUrl = 'wss://h0jpg5qd-7880.use2.devtunnels.ms/';
}
