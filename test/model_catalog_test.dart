import 'package:flutter_test/flutter_test.dart';
import 'package:privatelm/core/constants.dart';

void main() {
  group('AppConstants.availableModels', () {
    test('every catalog entry has the required fields', () {
      expect(AppConstants.availableModels, isNotEmpty);

      for (final model in AppConstants.availableModels) {
        final name = model['name'] ?? '';
        expect(name.trim(), isNotEmpty, reason: 'Missing model name');
        expect(model['filename']?.trim(), isNotEmpty,
            reason: 'Missing filename for $name');
        expect(model['url'], startsWith('https://'),
            reason: 'Missing HTTPS download URL for $name');
        expect(model['size'], matches(RegExp(r'^[\d.]+\s*(GB|MB)$')),
            reason: 'Invalid size for $name: ${model['size']}');
        expect(model['description']?.trim(), isNotEmpty,
            reason: 'Missing description for $name');
        expect(model['template']?.trim(), isNotEmpty,
            reason: 'Missing template for $name');
      }
    });

    test('filenames are unique', () {
      final filenames = AppConstants.availableModels
          .map((model) => model['filename'])
          .toList();

      expect(filenames.toSet().length, filenames.length,
          reason: 'Duplicate model filenames in the catalog');
    });
  });
}
