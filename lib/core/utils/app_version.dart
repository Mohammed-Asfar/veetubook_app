/// Minimal semantic-version parsing + comparison for the update check.
///
/// Handles the common shapes GitHub release tags come in: `v1.2.3`, `1.2.3`,
/// `1.2.3+4` (build metadata is ignored for ordering), and pre-release
/// suffixes like `1.2.3-beta` (treated as lower than the same release version).
/// Missing/garbage segments parse as 0 so a bad tag never crashes the app.
class AppVersion implements Comparable<AppVersion> {
  const AppVersion(this.major, this.minor, this.patch, {this.preRelease});

  final int major;
  final int minor;
  final int patch;

  /// Pre-release label (e.g. `beta.1`), or null for a normal release.
  final String? preRelease;

  /// Parses `[v]MAJOR.MINOR.PATCH[-pre][+build]`. Returns null if there is no
  /// usable numeric version at all.
  static AppVersion? tryParse(String? raw) {
    if (raw == null) return null;
    var s = raw.trim();
    if (s.isEmpty) return null;
    if (s.startsWith('v') || s.startsWith('V')) s = s.substring(1);

    // Strip build metadata (+...), keep pre-release (-...).
    s = s.split('+').first;
    String? pre;
    final dash = s.indexOf('-');
    if (dash >= 0) {
      pre = s.substring(dash + 1);
      s = s.substring(0, dash);
    }

    final parts = s.split('.');
    int at(int i) =>
        i < parts.length ? (int.tryParse(parts[i].trim()) ?? 0) : 0;
    // Require at least a leading number to be a real version.
    if (parts.isEmpty || int.tryParse(parts[0].trim()) == null) return null;

    return AppVersion(at(0), at(1), at(2), preRelease: pre);
  }

  @override
  int compareTo(AppVersion other) {
    if (major != other.major) return major.compareTo(other.major);
    if (minor != other.minor) return minor.compareTo(other.minor);
    if (patch != other.patch) return patch.compareTo(other.patch);
    // A pre-release is LOWER than the same version without one (1.0.0-beta < 1.0.0).
    final a = preRelease, b = other.preRelease;
    if (a == null && b == null) return 0;
    if (a == null) return 1; // this is a full release, other is pre -> higher
    if (b == null) return -1;
    return a.compareTo(b);
  }

  bool operator >(AppVersion other) => compareTo(other) > 0;
  bool operator <(AppVersion other) => compareTo(other) < 0;

  @override
  bool operator ==(Object other) =>
      other is AppVersion && compareTo(other) == 0;

  @override
  int get hashCode => Object.hash(major, minor, patch, preRelease);

  @override
  String toString() {
    final base = '$major.$minor.$patch';
    return preRelease == null ? base : '$base-$preRelease';
  }
}
