# ✅ Fix PreferenceService.getToken() - SELESAI

## 🐛 Error yang Diperbaiki

### Error Message:
```
The method 'getToken' isn't defined for the type 'PreferenceService'.
Try correcting the name to the name of an existing method, or defining a method named 'getToken'.
```

### Location:
- **File**: `lib/app/controllers/pembayaran_controller.dart`
- **Line**: 43, 73

---

## ✅ Solution

### Added Method to PreferenceService

**File**: `lib/app/services/preference_service.dart`

```dart
/// Get auth token from SharedPreferences
static Future<String> getToken() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('auth_token') ?? '';
}
```

**Features:**
- ✅ Static method (bisa dipanggil tanpa instance)
- ✅ Async untuk akses SharedPreferences
- ✅ Return empty string jika token tidak ada
- ✅ Konsisten dengan pattern yang sudah ada

---

## 🎯 Usage

### In Controller:
```dart
// Get token
final token = await PreferenceService.getToken();

// Use in API call
final response = await http.get(
  Uri.parse('${AppConfig.baseUrl}/api/endpoint'),
  headers: {'Authorization': 'Bearer $token'},
);
```

### In PembayaranController:
```dart
Future<void> fetchBorrowingDetail() async {
  final token = await PreferenceService.getToken();
  
  final response = await http.get(
    Uri.parse('${AppConfig.baseUrl}/api/borrowings/borrowings/$borrowingId'),
    headers: {'Authorization': 'Bearer $token'},
  );
  // ...
}
```

---

## 📊 Token Storage

### Save Token (Login):
```dart
final prefs = await SharedPreferences.getInstance();
await prefs.setString('auth_token', token);
```

### Get Token:
```dart
final token = await PreferenceService.getToken();
```

### Clear Token (Logout):
```dart
final prefs = await SharedPreferences.getInstance();
await prefs.remove('auth_token');
```

---

## ✅ Verification

### Compile Check:
```bash
flutter analyze
# Should show no errors
```

### Test:
```dart
// Test get token
final token = await PreferenceService.getToken();
print('Token: $token');
```

---

## 📝 Related Files

Files yang menggunakan `PreferenceService.getToken()`:
- ✅ `lib/app/controllers/pembayaran_controller.dart`
- ✅ Other controllers (if needed)

---

**Status**: ✅ FIXED & READY
