import 'package:flutter_test/flutter_test.dart';
import 'package:christmas_winter_theme/services/download_service.dart';

void main() {
  group('DownloadService URL Validation', () {
    late DownloadService service;

    setUp(() {
      service = DownloadService();
    });

    test('accepts valid HTTPS URLs', () {
      expect(service.validateUrl('https://example.com/file.mp3'), isNull);
      expect(
        service.validateUrl('https://cdn.music.com/audio/song.mp3'),
        isNull,
      );
    });

    test('rejects HTTP URLs', () {
      final result = service.validateUrl('http://example.com/file.mp3');
      expect(result, isNotNull);
      expect(result, contains('HTTPS'));
    });

    test('rejects FTP URLs', () {
      final result = service.validateUrl('ftp://example.com/file.mp3');
      expect(result, isNotNull);
    });

    test('rejects localhost URLs', () {
      final result = service.validateUrl('https://localhost/file.mp3');
      expect(result, isNotNull);
      expect(result, contains('local'));
    });

    test('rejects 127.0.0.1 URLs', () {
      final result = service.validateUrl('https://127.0.0.1/file.mp3');
      expect(result, isNotNull);
    });

    test('rejects private network 192.168.x.x URLs', () {
      final result = service.validateUrl('https://192.168.1.1/file.mp3');
      expect(result, isNotNull);
    });

    test('rejects private network 10.x.x.x URLs', () {
      final result = service.validateUrl('https://10.0.0.1/file.mp3');
      expect(result, isNotNull);
    });

    test('rejects private network 172.x.x.x URLs', () {
      final result = service.validateUrl('https://172.16.0.1/file.mp3');
      expect(result, isNotNull);
    });

    test('rejects empty host', () {
      final result = service.validateUrl('https:///file.mp3');
      expect(result, isNotNull);
    });
  });

  group('DownloadService Filename Validation', () {
    // We test the downloadToLocalInstance method indirectly through its
    // filename validation — it returns null for invalid filenames.
    // The actual download is not tested here (requires network).

    test('validates filename is not empty', () async {
      final service = DownloadService();
      // Empty filename should return null
      final result = await service.downloadToLocalInstance(
        'https://example.com/file.mp3',
        '',
      );
      expect(result, isNull);
    });

    test('rejects filename with path traversal', () async {
      final service = DownloadService();
      final result = await service.downloadToLocalInstance(
        'https://example.com/file.mp3',
        '../evil.mp3',
      );
      expect(result, isNull);
    });

    test('rejects filename with slashes', () async {
      final service = DownloadService();
      final result = await service.downloadToLocalInstance(
        'https://example.com/file.mp3',
        'path/file.mp3',
      );
      expect(result, isNull);
    });
  });
}
