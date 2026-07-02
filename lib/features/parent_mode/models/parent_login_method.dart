class ParentLoginMethod {
  final String provider;
  final String label;
  final bool connected;
  final String? iconAssetPath;

  const ParentLoginMethod({
    required this.provider,
    required this.label,
    required this.connected,
    this.iconAssetPath,
  });
}
