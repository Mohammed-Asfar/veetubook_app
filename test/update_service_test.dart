// Tests the GitHub-releases update check: newer-version detection, "already up
// to date", skip-this-version, and graceful failure — all without real network.

import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:veetubook/features/update/data/update_service.dart';

http.Client _clientReturning(String tag, {int status = 200}) {
  return MockClient((req) async {
    final body = jsonEncode({
      'tag_name': tag,
      'name': 'Release $tag',
      'body': 'Some notes',
      'html_url': 'https://github.com/o/r/releases/tag/$tag',
    });
    return http.Response(body, status);
  });
}

UpdateService _service(
  SharedPreferences prefs,
  http.Client client, {
  String current = '1.0.0',
}) =>
    UpdateService(
      prefs: prefs,
      owner: 'o',
      repo: 'r',
      client: client,
      currentVersion: () async => current,
    );

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late SharedPreferences prefs;
  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    prefs = await SharedPreferences.getInstance();
  });

  test('offers the release when the tag is newer than the installed version',
      () async {
    final s = _service(prefs, _clientReturning('v1.1.0'), current: '1.0.0');
    final r = await s.checkForUpdate();
    expect(r, isNotNull);
    expect(r!.tagName, 'v1.1.0');
    expect(r.notes, 'Some notes');
  });

  test('returns null when already on the latest version', () async {
    final s = _service(prefs, _clientReturning('v1.0.0'), current: '1.0.0');
    expect(await s.checkForUpdate(), isNull);
  });

  test('returns null when the installed version is newer (dev build)', () async {
    final s = _service(prefs, _clientReturning('v0.9.0'), current: '1.0.0');
    expect(await s.checkForUpdate(), isNull);
  });

  test('skipped tag is not offered again, but a later tag still is', () async {
    final newer = _clientReturning('v1.1.0');
    final s = _service(prefs, newer, current: '1.0.0');

    // User skips 1.1.0.
    await s.skip('v1.1.0');
    expect(await s.checkForUpdate(), isNull);

    // A newer 1.2.0 release still prompts despite the earlier skip.
    final s2 = _service(prefs, _clientReturning('v1.2.0'), current: '1.0.0');
    final r = await s2.checkForUpdate();
    expect(r?.tagName, 'v1.2.0');
  });

  test('non-200 (e.g. no releases yet) returns null, not an error', () async {
    final s = _service(prefs, _clientReturning('v9.9.9', status: 404));
    expect(await s.checkForUpdate(), isNull);
  });

  test('network/parse errors are swallowed (returns null)', () async {
    final throwing = MockClient((_) async => throw Exception('offline'));
    final s = _service(prefs, throwing, current: '1.0.0');
    expect(await s.checkForUpdate(), isNull);
  });
}
