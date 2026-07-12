/// A GitHub release relevant to the in-app update check.
class AppRelease {
  const AppRelease({
    required this.tagName,
    required this.name,
    required this.notes,
    required this.htmlUrl,
  });

  /// Raw tag, e.g. `v1.2.0`.
  final String tagName;

  /// Human title of the release (falls back to the tag if empty).
  final String name;

  /// Release notes / changelog body (markdown).
  final String notes;

  /// The release page on github.com (opened in the browser to update).
  final String htmlUrl;
}
