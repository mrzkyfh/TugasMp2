class ApiConstants {
  static const String cerebrasApiKey = String.fromEnvironment(
    'CEREBRAS_API_KEY',
    defaultValue: 'csk-w2weexvmrxh6crtpjxyxet8m25kddcxp3xtxdn6tpv925wy3',
  );

  static const String cerebrasBaseUrl = 'https://api.cerebras.ai/v1';
  static const String cerebrasModel = 'llama3.1-8b';

  static const String supabaseUrl = String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: 'https://placeholder.supabase.co',
  );

  static const String supabaseAnonKey = String.fromEnvironment(
    'SUPABASE_ANON_KEY',
    defaultValue: 'your-anon-key-here',
  );

  static bool get hasCerebrasApiKey => cerebrasApiKey.trim().isNotEmpty;
}
