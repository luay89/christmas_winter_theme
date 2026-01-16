# SECURITY POLICY

Mandatory rules:
- No arbitrary file downloads
- All external URLs must be validated
- No debug signing in release
- Scoped Storage only (Android 10+)
- Platform channels must fail gracefully

Prohibited:
- Plaintext storage of sensitive paths
- Broad storage permissions
- Unhandled platform exceptions
