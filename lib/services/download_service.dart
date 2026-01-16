import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import '../utils/app_logger.dart';

/// Service for downloading files from remote URLs.
/// 
/// Security: Only allows downloads from validated URLs.
/// This service is designed to be injectable (not static singleton).
class DownloadService {
  /// Allowed URL schemes for downloads
  static const List<String> _allowedSchemes = ['https'];
  
  /// Maximum file size (10 MB)
  static const int _maxFileSizeBytes = 10 * 1024 * 1024;

  final http.Client _client;

  /// Creates a new instance of DownloadService.
  /// 
  /// For production use, use the default constructor.
  /// For testing, inject a mock http.Client.
  DownloadService({http.Client? client}) : _client = client ?? http.Client();

  /// Default singleton instance for backward compatibility during migration.
  static final DownloadService _instance = DownloadService();
  static DownloadService get instance => _instance;

  /// Validates a URL for security requirements.
  /// 
  /// Returns null if valid, or an error message if invalid.
  String? validateUrl(String url) {
    try {
      final uri = Uri.parse(url);
      
      if (!_allowedSchemes.contains(uri.scheme.toLowerCase())) {
        return 'Only HTTPS URLs are allowed for security reasons';
      }
      
      if (uri.host.isEmpty) {
        return 'Invalid URL: missing host';
      }
      
      // Prevent localhost/internal network access
      if (uri.host == 'localhost' || 
          uri.host == '127.0.0.1' ||
          uri.host.startsWith('192.168.') ||
          uri.host.startsWith('10.') ||
          uri.host.startsWith('172.')) {
        return 'Downloads from local/internal networks are not allowed';
      }
      
      return null; // Valid
    } catch (e) {
      return 'Invalid URL format: $e';
    }
  }

  /// Downloads a remote URL to app documents and returns the absolute file path.
  /// 
  /// Security:
  /// - Only HTTPS URLs are allowed
  /// - File size is limited to prevent abuse
  /// - Local/internal network URLs are blocked
  Future<String?> downloadToLocalInstance(String url, String fileName) async {
    // Validate URL
    final validationError = validateUrl(url);
    if (validationError != null) {
      AppLogger.warning('Download blocked: $validationError (URL: $url)');
      return null;
    }

    // Validate filename
    if (fileName.isEmpty || fileName.contains('..') || fileName.contains('/')) {
      AppLogger.warning('Invalid filename: $fileName');
      return null;
    }

    try {
      AppLogger.info('Starting download: $url');
      
      final response = await _client.get(Uri.parse(url));
      
      if (response.statusCode != 200) {
        AppLogger.warning('Download failed: HTTP ${response.statusCode}');
        return null;
      }

      // Check file size
      if (response.bodyBytes.length > _maxFileSizeBytes) {
        AppLogger.warning('Download blocked: file too large (${response.bodyBytes.length} bytes)');
        return null;
      }

      final dir = await getApplicationDocumentsDirectory();
      final file = File('${dir.path}/$fileName');
      await file.writeAsBytes(response.bodyBytes);
      
      AppLogger.info('Download complete: ${file.path}');
      return file.path;
    } catch (e, stack) {
      AppLogger.error('Download error', error: e, stackTrace: stack);
      return null;
    }
  }

  void disposeInstance() {
    _client.close();
  }

  // ============================================
  // LEGACY STATIC METHODS (for backward compatibility)
  // ============================================

  static Future<String?> downloadToLocal(String url, String fileName) =>
      _instance.downloadToLocalInstance(url, fileName);
}
