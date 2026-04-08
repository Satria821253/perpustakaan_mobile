# ✅ Setup Pembayaran Simulasi - SUDAH DIIMPLEMENTASI

## 🎯 Yang Sudah Dilakukan

### 1. ✅ Update Controller
**File**: `lib/app/controllers/pembayaran_controller.dart`

**Fitur yang sudah ada:**
- ✅ Fetch borrowing detail dari API
- ✅ Fetch user koin dari API
- ✅ Hitung denda otomatis (hari terlambat × Rp 1.000)
- ✅ Validasi saldo koin
- ✅ Support semua metode pembayaran:
  - Kasir → `payment_method: 'kasir'`
  - GoPay → `payment_method: 'gopay'`
  - OVO → `payment_method: 'ovo'`
  - DANA → `payment_method: 'dana'`
  - ShopeePay → `payment_method: 'shopeepay'`
  - Koin → `payment_method: 'koin'`
  - QR Code → `payment_method: 'qris'`
- ✅ Loading states
- ✅ Error handling
- ✅ Success/error snackbar

### 2. ✅ Update UI
**File**: `lib/app/views/pembayaran/pembayaran_screen.dart`

**Fitur yang sudah ada:**
- ✅ Loading screen saat fetch data
- ✅ Display data dari API (bukan dummy)
- ✅ Reactive UI dengan Obx

---

## 🔌 API Endpoints yang Digunakan

### 1. Get Borrowing Detail
```
GET /api/borrowings/borrowings/{id}
Authorization: Bearer {token}
```

**Response yang digunakan:**
```json
{
  "borrowing": {
    "book_judul": "Naruto",
    "pengarang": "Masashi Kishimoto",
    "cover_image": "url",
    "tanggal_kembali_formatted": "12 Mar 2026",
    "hari_tersisa": -5  // negatif = terlambat
  }
}
```

### 2. Get User Profile
```
GET /api/user/profile
Authorization: Bearer {token}
```

**Response yang digunakan:**
```json
{
  "koin": 2450
}
```

### 3. Pay Fine (SIMULASI)
```
POST /api/borrowings/pay-fine-before-return
Authorization: Bearer {token}
Content-Type: application/json

{
  "borrowing_id": 123,
  "payment_method": "gopay"  // atau "ovo", "dana", "shopeepay", "koin", "qris", "kasir"
}
```

**Response:**
```json
{
  "message": "Pembayaran denda berhasil",
  "amount": 10000,
  "payment_method": "gopay",
  "transaction_id": "TRX-1234567890-123",
  "info": "Pembayaran berhasil (simulasi)"
}
```

---

## 🚀 Cara Menggunakan

### 1. Navigasi ke Halaman Pembayaran

```dart
import 'package:ei_books/app/views/pembayaran/pembayaran_screen.dart';

// Dari halaman detail peminjaman
Get.to(() => PembayaranScreen(borrowingId: borrowing.id));

// Dengan callback
final result = await Get.to(() => PembayaranScreen(borrowingId: borrowing.id));
if (result == true) {
  // Pembayaran berhasil, refresh data
  fetchBorrowingList();
}
```

### 2. Flow Pembayaran

**User Flow:**
1. User buka halaman pembayaran
2. Loading → fetch data dari API
3. Tampil info buku & denda
4. User pilih metode pembayaran
5. User klik "Konfirmasi"
6. Loading → kirim ke API
7. Success → snackbar + navigate back
8. Error → snackbar error

**Backend Flow (Simulasi):**
1. Terima request pembayaran
2. Validasi borrowing_id
3. Validasi payment_method
4. Jika `koin`: validasi & potong saldo
5. Jika lainnya: langsung sukses (simulasi)
6. Insert ke `payment_transactions`
7. Update `borrowings.denda_dibayar = true`
8. Return success response

---

## 🧪 Testing

### Test 1: Bayar dengan GoPay (Simulasi)
1. Buka halaman pembayaran
2. Pilih "E-Wallet"
3. Pilih "GoPay"
4. Klik "Konfirmasi"
5. ✅ Expected: Langsung sukses, snackbar muncul

### Test 2: Bayar dengan Koin (Real)
1. Buka halaman pembayaran
2. Pilih "Koin Aplikasi"
3. Jika saldo cukup: klik "Konfirmasi"
4. ✅ Expected: Saldo koin berkurang, denda lunas

### Test 3: Koin Tidak Cukup
1. Buka halaman pembayaran
2. Pilih "Koin Aplikasi"
3. ✅ Expected: Button disabled, badge "Tidak cukup"

### Test 4: Bayar di Kasir
1. Buka halaman pembayaran
2. Pilih "Bayar di Perpustakaan"
3. Klik "Konfirmasi"
4. ✅ Expected: Sukses, user bisa generate kode pengembalian

---

## 📊 Data Flow

```
User Action → Flutter Controller → API Backend → Database
     ↓              ↓                    ↓            ↓
  Pilih         Kirim POST         Validasi      Insert
  Metode        + Token            & Proses      Record
     ↓              ↓                    ↓            ↓
  Klik          Loading            Success       Update
  Konfirmasi    State              Response      Status
     ↓              ↓                    ↓            ↓
  Wait          Parse              Show          Return
  Response      JSON               Snackbar      Result
```

---

## 🔧 Konfigurasi

### Base URL
**File**: `lib/app/core/app_config.dart`
```dart
class AppConfig {
  static const baseUrl = 'http://10.122.73.122:5000';
}
```

### Token Storage
**File**: `lib/app/services/preference_service.dart`
```dart
static Future<String> getToken() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('token') ?? '';
}
```

---

## ✅ Checklist Implementasi

### Flutter (DONE):
- [x] Update controller dengan API integration
- [x] Fetch borrowing detail
- [x] Fetch user koin
- [x] Implement konfirmasi() method
- [x] Handle all payment methods
- [x] Loading states
- [x] Error handling
- [x] Success snackbar
- [x] Navigate back with result

### Backend (PERLU DICEK):
- [ ] Endpoint `/pay-fine-before-return` sudah ada?
- [ ] Support semua payment_method?
- [ ] Validasi koin?
- [ ] Insert ke `payment_transactions`?
- [ ] Update `borrowings.denda_dibayar`?
- [ ] Generate transaction_id?

### Testing (TODO):
- [ ] Test dengan GoPay
- [ ] Test dengan OVO
- [ ] Test dengan DANA
- [ ] Test dengan ShopeePay
- [ ] Test dengan Koin (saldo cukup)
- [ ] Test dengan Koin (saldo tidak cukup)
- [ ] Test dengan QRIS
- [ ] Test dengan Kasir
- [ ] Test error handling
- [ ] Test loading states

---

## 🐛 Troubleshooting

### Issue: "Gagal memuat data"
**Cause**: API endpoint tidak tersedia atau token invalid
**Solution**: 
1. Cek `AppConfig.baseUrl` sudah benar
2. Cek token masih valid
3. Cek endpoint `/api/borrowings/borrowings/{id}` sudah ada

### Issue: "Pembayaran gagal"
**Cause**: Backend belum implement endpoint
**Solution**: 
1. Cek endpoint `/api/borrowings/pay-fine-before-return` sudah ada
2. Cek request body format sudah benar
3. Cek response format sesuai

### Issue: Koin tidak berkurang
**Cause**: Backend tidak potong saldo koin
**Solution**: 
1. Cek backend logic untuk `payment_method: 'koin'`
2. Pastikan ada query `UPDATE anggota SET koin = koin - ?`

---

## 🎯 Next Steps

1. **Test Backend**: Pastikan semua endpoint sudah ready
2. **Test Flow**: Test semua metode pembayaran
3. **Fix Bugs**: Perbaiki jika ada error
4. **Demo**: Siap untuk presentasi

---

## 💡 Catatan Penting

### Simulasi vs Real Payment Gateway

**Sekarang (Simulasi):**
- ✅ Semua pembayaran langsung sukses
- ✅ Tidak ada redirect ke app external
- ✅ Tidak ada biaya transaksi
- ✅ Cocok untuk development & demo

**Future (Real Payment Gateway):**
- Integrasi Midtrans/Xendit
- Redirect ke app GoPay/OVO/dll
- Biaya transaksi ~2.9%
- Webhook untuk konfirmasi pembayaran

**Untuk sekarang, SIMULASI sudah cukup!** 🎉

---

## 📞 Support

Jika ada issue:
1. Cek dokumentasi ini
2. Cek kode di `lib/app/controllers/pembayaran_controller.dart`
3. Test dengan Postman/curl dulu
4. Debug dengan print/log

**Status**: ✅ READY FOR TESTING
