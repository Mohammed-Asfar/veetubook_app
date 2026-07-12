// Tests semantic-version parsing + ordering used by the update check.

import 'package:flutter_test/flutter_test.dart';
import 'package:veetubook/core/utils/app_version.dart';

void main() {
  test('parses v-prefixed, plain, build-metadata and pre-release tags', () {
    expect(AppVersion.tryParse('v1.2.3').toString(), '1.2.3');
    expect(AppVersion.tryParse('1.2.3').toString(), '1.2.3');
    expect(AppVersion.tryParse('1.2.3+9').toString(), '1.2.3'); // build ignored
    expect(AppVersion.tryParse('1.2').toString(), '1.2.0'); // missing patch -> 0
    expect(AppVersion.tryParse('v2.0.0-beta.1').toString(), '2.0.0-beta.1');
  });

  test('rejects empty / non-numeric tags', () {
    expect(AppVersion.tryParse(null), isNull);
    expect(AppVersion.tryParse(''), isNull);
    expect(AppVersion.tryParse('latest'), isNull);
  });

  test('orders by major, minor, patch', () {
    final v = AppVersion.tryParse;
    expect(v('1.0.1')! > v('1.0.0')!, isTrue);
    expect(v('1.1.0')! > v('1.0.9')!, isTrue);
    expect(v('2.0.0')! > v('1.9.9')!, isTrue);
    expect(v('1.0.0')! > v('1.0.0')!, isFalse);
    expect(v('1.0.0')! < v('1.0.1')!, isTrue);
  });

  test('a pre-release is lower than the same final version', () {
    final v = AppVersion.tryParse;
    expect(v('1.0.0')! > v('1.0.0-beta')!, isTrue);
    expect(v('1.0.0-beta')! < v('1.0.0')!, isTrue);
  });
}
