class ApiConstants {
  static const String cerebrasApiKey = String.fromEnvironment(
    'CEREBRAS_API_KEY',
    defaultValue: 'csk-w2weexvmrxh6crtpjxyxet8m25kddcxp3xtxdn6tpv925wy3',
  );

  static const String cerebrasBaseUrl = 'https://api.cerebras.ai/v1';
  static const String cerebrasModel = 'llama3.1-8b';

  static const String supabaseUrl = String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: 'https://xdlrobokiaecthbspjcw.supabase.co',
  );

  static const String supabaseAnonKey = String.fromEnvironment(
    'SUPABASE_ANON_KEY',
    defaultValue:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InhkbHJvYm9raWFlY3RoYnNwamN3Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3Nzc4OTIxOTIsImV4cCI6MjA5MzQ2ODE5Mn0.qx-vS7Jefyq4OnR1eccK7cIJBfPFz_voiBqudahhMbc',
  );

  static bool get hasCerebrasApiKey => cerebrasApiKey.trim().isNotEmpty;
}
