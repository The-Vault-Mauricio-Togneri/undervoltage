Environment environment = const Environment(
  matchFinishedUrl: '',
  apiKey: '',
  port: 0,
);

class Environment {
  final String matchFinishedUrl;
  final String apiKey;
  final int port;
  final String? chain;
  final String? key;

  const Environment({
    required this.matchFinishedUrl,
    required this.apiKey,
    required this.port,
    this.chain,
    this.key,
  });
}
