import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/utils/app_version.dart';
import '../domain/app_release.dart';

/// Checks GitHub Releases for a newer version of the app and remembers when the
/// user chooses to skip a particular version.
///
/// Public-repo `releases/latest` needs no auth. Network/parse failures are
/// swallowed (returns null) — an update check must never break app launch.
class UpdateService {
  UpdateService({
    required SharedPreferences prefs,
    required this.owner,
    required this.repo,
    http.Client? client,
    Future<String> Function()? currentVersion,
  })  : _prefs = prefs,
        _client = client ?? http.Client(),
        _currentVersion = currentVersion ?? _installedVersion;

  final SharedPreferences _prefs;
  final http.Client _client;
  final Future<String> Function() _currentVersion;

  final String owner;
  final String repo;

  static const _kSkippedTag = 'update.skippedTag';

  static Future<String> _installedVersion() async {
    final info = await PackageInfo.fromPlatform();
    return info.version; // e.g. "1.0.0"
  }

  Uri get _latestUri =>
      Uri.parse('https://api.github.com/repos/$owner/$repo/releases/latest');

  /// Returns the latest release IF it is newer than the installed version and
  /// the user hasn't skipped that exact tag. Returns null otherwise (already
  /// up to date, skipped, or the check failed).
  Future<AppRelease?> checkForUpdate() async {
    try {
      final res = await _client.get(
        _latestUri,
        headers: const {
          'Accept': 'application/vnd.github+json',
          'X-GitHub-Api-Version': '2022-11-28',
        },
      ).timeout(const Duration(seconds: 8));

      if (res.statusCode != 200) return null; // e.g. 404 = no releases yet
      final json = jsonDecode(res.body) as Map<String, dynamic>;

      final tag = (json['tag_name'] as String?)?.trim();
      if (tag == null || tag.isEmpty) return null;

      final latest = AppVersion.tryParse(tag);
      final current = AppVersion.tryParse(await _currentVersion());
      if (latest == null || current == null) return null;

      // Not newer -> nothing to offer.
      if (!(latest > current)) return null;
      // User asked to skip exactly this tag.
      if (_prefs.getString(_kSkippedTag) == tag) return null;

      return AppRelease(
        tagName: tag,
        name: (json['name'] as String?)?.trim().isNotEmpty == true
            ? (json['name'] as String).trim()
            : tag,
        notes: (json['body'] as String?)?.trim() ?? '',
        htmlUrl: (json['html_url'] as String?) ??
            'https://github.com/$owner/$repo/releases',
      );
    } catch (_) {
      // Offline, timeout, JSON error, etc. — silently ignore.
      return null;
    }
  }

  /// Remember not to prompt again for this release tag.
  Future<void> skip(String tagName) => _prefs.setString(_kSkippedTag, tagName);
}
