# 🔔 Backend Notification Specification

## 📋 Overview

Dokumentasi ini menjelaskan spesifikasi backend untuk mengirim push notification ke mobile app menggunakan Firebase Cloud Messaging (FCM).

---

## 🎯 Notification Types

### 1. **Peminjaman (Borrowing)**

#### 1.1 Peminjaman Disetujui
```json
{
  "notification": {
    "title": "Peminjaman Disetujui ✅",
    "body": "Peminjaman buku [Judul Buku] telah disetujui. Silakan ambil di perpustakaan."
  },
  "data": {
    "type": "borrowing_approved",
    "borrowing_id": "47",
    "book_id": "1",
    "book_title": "Dilan: Dia adalah Dilanku tahun 1990"
  }
}
```

**Kapan dikirim:** Setelah petugas approve peminjaman

**Action:** Redirect ke `/detail-peminjaman?id={borrowing_id}`

---

#### 1.2 Peminjaman Ditolak
```json
{
  "notification": {
    "title": "Peminjaman Ditolak ❌",
    "body": "Peminjaman buku [Judul Buku] ditolak. [Alasan]"
  },
  "data": {
    "type": "borrowing_denied",
    "borrowing_id": "47",
    "book_id": "1",
    "book_title": "Dilan: Dia adalah Dilanku tahun 1990",
    "reason": "Stok buku tidak tersedia"
  }
}
```

**Kapan dikirim:** Setelah petugas reject peminjaman

**Action:** Show dialog dengan alasan

---

### 2. **Perpanjangan (Extension)**

#### 2.1 Perpanjangan Disetujui
```json
{
  "notification": {
    "title": "Perpanjangan Disetujui ✅",
    "body": "Perpanjangan buku [Judul Buku] sebanyak [X] hari telah disetujui."
  },
  "data": {
    "type": "extension_approved",
    "borrowing_id": "47",
    "extension_id": "12",
    "book_title": "Dilan: Dia adalah Dilanku tahun 1990",
    "duration_days": "7",
    "new_return_date": "2026-05-06"
  }
}
```

**Kapan dikirim:** Setelah petugas approve perpanjangan

**Action:** Redirect ke `/detail-perpanjang?id={borrowing_id}` dengan overlay success

---

#### 2.2 Perpanjangan Ditolak
```json
{
  "notification": {
    "title": "Perpanjangan Ditolak ❌",
    "body": "Perpanjangan buku [Judul Buku] ditolak. [Alasan]"
  },
  "data": {
    "type": "extension_denied",
    "borrowing_id": "47",
    "extension_id": "12",
    "book_title": "Dilan: Dia adalah Dilanku tahun 1990",
    "reason": "Buku sudah direservasi pengguna lain"
  }
}
```

**Kapan dikirim:** Setelah petugas reject perpanjangan

**Action:** Redirect ke `/detail-perpanjang?id={borrowing_id}` dengan overlay denied

---

### 3. **Pengembalian (Return)**

#### 3.1 Pengembalian Berhasil
```json
{
  "notification": {
    "title": "Pengembalian Berhasil ✅",
    "body": "Buku [Judul Buku] telah berhasil dikembalikan. Terima kasih!"
  },
  "data": {
    "type": "return_success",
    "borrowing_id": "47",
    "book_title": "Dilan: Dia adalah Dilanku tahun 1990",
    "return_date": "2026-04-29",
    "koin_earned": "50"
  }
}
```

**Kapan dikirim:** Setelah petugas konfirmasi pengembalian

**Action:** Redirect ke `/detail-pengembalian?id={borrowing_id}` dengan overlay success

---

#### 3.2 Pengembalian Ditolak
```json
{
  "notification": {
    "title": "Pengembalian Ditolak ❌",
    "body": "Pengembalian buku [Judul Buku] ditolak. [Alasan]"
  },
  "data": {
    "type": "return_denied",
    "borrowing_id": "47",
    "book_title": "Dilan: Dia adalah Dilanku tahun 1990",
    "reason": "Kondisi buku rusak, perlu pembayaran denda"
  }
}
```

**Kapan dikirim:** Setelah petugas reject pengembalian

**Action:** Show dialog dengan alasan

---

### 4. **Pembayaran (Payment)**

#### 4.1 Pembayaran Berhasil
```json
{
  "notification": {
    "title": "Pembayaran Berhasil ✅",
    "body": "Pembayaran denda sebesar Rp [Nominal] berhasil diproses."
  },
  "data": {
    "type": "payment_success",
    "payment_id": "89",
    "borrowing_id": "47",
    "amount": "10000",
    "payment_method": "koin"
  }
}
```

**Kapan dikirim:** Setelah pembayaran denda berhasil

**Action:** Redirect ke detail pembayaran dengan overlay success

---

#### 4.2 Pembayaran Gagal
```json
{
  "notification": {
    "title": "Pembayaran Gagal ❌",
    "body": "Pembayaran denda gagal diproses. Silakan coba lagi."
  },
  "data": {
    "type": "payment_failed",
    "payment_id": "89",
    "borrowing_id": "47",
    "amount": "10000",
    "reason": "Saldo koin tidak mencukupi"
  }
}
```

**Kapan dikirim:** Jika pembayaran gagal

**Action:** Show dialog dengan alasan

---

### 5. **Reminder & Alert**

#### 5.1 Reminder Jatuh Tempo
```json
{
  "notification": {
    "title": "Reminder: Buku Akan Jatuh Tempo ⏰",
    "body": "Buku [Judul Buku] akan jatuh tempo dalam [X] hari. Segera kembalikan atau perpanjang."
  },
  "data": {
    "type": "reminder_due_soon",
    "borrowing_id": "47",
    "book_title": "Dilan: Dia adalah Dilanku tahun 1990",
    "days_remaining": "3",
    "due_date": "2026-04-29"
  }
}
```

**Kapan dikirim:** 3 hari sebelum jatuh tempo (daily check)

**Action:** Redirect ke `/detail-peminjaman?id={borrowing_id}`

---

#### 5.2 Alert Terlambat
```json
{
  "notification": {
    "title": "Buku Terlambat ⚠️",
    "body": "Buku [Judul Buku] sudah terlambat [X] hari. Denda: Rp [Nominal]"
  },
  "data": {
    "type": "alert_overdue",
    "borrowing_id": "47",
    "book_title": "Dilan: Dia adalah Dilanku tahun 1990",
    "days_overdue": "2",
    "fine_amount": "4000"
  }
}
```

**Kapan dikirim:** Setiap hari setelah jatuh tempo

**Action:** Redirect ke `/detail-peminjaman?id={borrowing_id}`

---

## 🔧 Backend Implementation

### 1. Database Schema

#### Table: `fcm_tokens`
```sql
CREATE TABLE fcm_tokens (
  id INT PRIMARY KEY AUTO_INCREMENT,
  user_id INT NOT NULL,
  token VARCHAR(255) NOT NULL,
  device_type ENUM('android', 'ios', 'web') DEFAULT 'android',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  UNIQUE KEY unique_user_token (user_id, token)
);
```

#### Table: `notifications` (Optional - untuk history)
```sql
CREATE TABLE notifications (
  id INT PRIMARY KEY AUTO_INCREMENT,
  user_id INT NOT NULL,
  type VARCHAR(50) NOT NULL,
  title VARCHAR(255) NOT NULL,
  body TEXT NOT NULL,
  data JSON,
  is_read BOOLEAN DEFAULT FALSE,
  sent_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);
```

---

### 2. API Endpoints

#### 2.1 Register FCM Token
```javascript
POST /api/fcm/register
Headers: Authorization: Bearer {token}
Body: {
  "fcm_token": "dXJk8fH...",
  "device_type": "android"
}

Response: {
  "success": true,
  "message": "FCM token registered"
}
```

#### 2.2 Unregister FCM Token
```javascript
POST /api/fcm/unregister
Headers: Authorization: Bearer {token}
Body: {
  "fcm_token": "dXJk8fH..."
}

Response: {
  "success": true,
  "message": "FCM token removed"
}
```

---

### 3. Notification Service (Node.js)

#### Install Dependencies
```bash
npm install firebase-admin
```

#### Initialize Firebase Admin
```javascript
// services/fcm.service.js
const admin = require('firebase-admin');
const serviceAccount = require('../config/firebase-service-account.json');

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount)
});

class FCMService {
  /**
   * Send notification to user
   * @param {number} userId - User ID
   * @param {object} notification - Notification payload
   * @param {object} data - Data payload
   */
  async sendToUser(userId, notification, data) {
    try {
      // Get user's FCM tokens
      const tokens = await this.getUserTokens(userId);
      
      if (tokens.length === 0) {
        console.log(`No FCM tokens found for user ${userId}`);
        return;
      }

      const message = {
        notification: {
          title: notification.title,
          body: notification.body,
        },
        data: this.convertDataToStrings(data),
        tokens: tokens,
        android: {
          priority: 'high',
          notification: {
            sound: 'default',
            channelId: 'default',
          }
        },
        apns: {
          payload: {
            aps: {
              sound: 'default',
              badge: 1,
            }
          }
        }
      };

      const response = await admin.messaging().sendMulticast(message);
      
      console.log(`Notification sent to user ${userId}:`, response);
      
      // Remove invalid tokens
      if (response.failureCount > 0) {
        await this.removeInvalidTokens(tokens, response.responses);
      }

      // Save to notification history (optional)
      await this.saveNotificationHistory(userId, notification, data);

      return response;
    } catch (error) {
      console.error('Error sending notification:', error);
      throw error;
    }
  }

  /**
   * Get user's FCM tokens from database
   */
  async getUserTokens(userId) {
    const db = require('../config/database');
    const [rows] = await db.query(
      'SELECT token FROM fcm_tokens WHERE user_id = ?',
      [userId]
    );
    return rows.map(row => row.token);
  }

  /**
   * Convert data object to strings (FCM requirement)
   */
  convertDataToStrings(data) {
    const result = {};
    for (const [key, value] of Object.entries(data)) {
      result[key] = String(value);
    }
    return result;
  }

  /**
   * Remove invalid tokens
   */
  async removeInvalidTokens(tokens, responses) {
    const db = require('../config/database');
    const invalidTokens = [];

    responses.forEach((response, index) => {
      if (!response.success) {
        const error = response.error;
        if (
          error.code === 'messaging/invalid-registration-token' ||
          error.code === 'messaging/registration-token-not-registered'
        ) {
          invalidTokens.push(tokens[index]);
        }
      }
    });

    if (invalidTokens.length > 0) {
      await db.query(
        'DELETE FROM fcm_tokens WHERE token IN (?)',
        [invalidTokens]
      );
      console.log(`Removed ${invalidTokens.length} invalid tokens`);
    }
  }

  /**
   * Save notification to history
   */
  async saveNotificationHistory(userId, notification, data) {
    const db = require('../config/database');
    await db.query(
      'INSERT INTO notifications (user_id, type, title, body, data) VALUES (?, ?, ?, ?, ?)',
      [userId, data.type, notification.title, notification.body, JSON.stringify(data)]
    );
  }
}

module.exports = new FCMService();
```

---

### 4. Integration Examples

#### 4.1 Perpanjangan Disetujui
```javascript
// controllers/extension.controller.js
const fcmService = require('../services/fcm.service');

async function approveExtension(req, res) {
  const { extension_id } = req.body;
  
  try {
    // Update extension status
    await db.query(
      'UPDATE extension_requests SET status = ?, approved_at = NOW() WHERE id = ?',
      ['approved', extension_id]
    );

    // Get extension details
    const [extension] = await db.query(`
      SELECT er.*, b.user_id, bk.judul as book_title, er.durasi_hari,
             DATE_ADD(b.tanggal_kembali, INTERVAL er.durasi_hari DAY) as new_return_date
      FROM extension_requests er
      JOIN borrowings b ON er.borrowing_id = b.id
      JOIN books bk ON b.book_id = bk.id
      WHERE er.id = ?
    `, [extension_id]);

    const ext = extension[0];

    // Update borrowing tanggal_kembali
    await db.query(
      'UPDATE borrowings SET tanggal_kembali = ?, jumlah_perpanjangan = jumlah_perpanjangan + 1 WHERE id = ?',
      [ext.new_return_date, ext.borrowing_id]
    );

    // Send notification
    await fcmService.sendToUser(
      ext.user_id,
      {
        title: 'Perpanjangan Disetujui ✅',
        body: `Perpanjangan buku ${ext.book_title} sebanyak ${ext.durasi_hari} hari telah disetujui.`
      },
      {
        type: 'extension_approved',
        borrowing_id: ext.borrowing_id,
        extension_id: extension_id,
        book_title: ext.book_title,
        duration_days: ext.durasi_hari,
        new_return_date: ext.new_return_date
      }
    );

    res.json({ success: true, message: 'Extension approved' });
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: 'Failed to approve extension' });
  }
}
```

#### 4.2 Pengembalian Berhasil
```javascript
// controllers/return.controller.js
async function confirmReturn(req, res) {
  const { borrowing_id, kondisi_buku } = req.body;
  
  try {
    // Update borrowing status
    await db.query(
      'UPDATE borrowings SET status = ?, tanggal_dikembalikan = NOW(), kondisi_buku = ? WHERE id = ?',
      ['dikembalikan', kondisi_buku, borrowing_id]
    );

    // Get borrowing details
    const [borrowing] = await db.query(`
      SELECT b.*, u.id as user_id, bk.judul as book_title
      FROM borrowings b
      JOIN users u ON b.user_id = u.id
      JOIN books bk ON b.book_id = bk.id
      WHERE b.id = ?
    `, [borrowing_id]);

    const brw = borrowing[0];

    // Calculate koin earned
    const koinEarned = 50; // Base koin
    await db.query(
      'UPDATE users SET koin = koin + ? WHERE id = ?',
      [koinEarned, brw.user_id]
    );

    // Send notification
    await fcmService.sendToUser(
      brw.user_id,
      {
        title: 'Pengembalian Berhasil ✅',
        body: `Buku ${brw.book_title} telah berhasil dikembalikan. Terima kasih!`
      },
      {
        type: 'return_success',
        borrowing_id: borrowing_id,
        book_title: brw.book_title,
        return_date: new Date().toISOString().split('T')[0],
        koin_earned: koinEarned
      }
    );

    res.json({ success: true, message: 'Return confirmed', koin_earned: koinEarned });
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: 'Failed to confirm return' });
  }
}
```

#### 4.3 Reminder Jatuh Tempo (Cron Job)
```javascript
// jobs/reminder.job.js
const cron = require('node-cron');
const fcmService = require('../services/fcm.service');

// Run every day at 9 AM
cron.schedule('0 9 * * *', async () => {
  console.log('Running due date reminder job...');
  
  try {
    const db = require('../config/database');
    
    // Get borrowings that will be due in 3 days
    const [borrowings] = await db.query(`
      SELECT b.id, b.user_id, bk.judul as book_title,
             DATEDIFF(b.tanggal_kembali, CURDATE()) as days_remaining,
             b.tanggal_kembali
      FROM borrowings b
      JOIN books bk ON b.book_id = bk.id
      WHERE b.status = 'dipinjam'
      AND DATEDIFF(b.tanggal_kembali, CURDATE()) = 3
    `);

    for (const brw of borrowings) {
      await fcmService.sendToUser(
        brw.user_id,
        {
          title: 'Reminder: Buku Akan Jatuh Tempo ⏰',
          body: `Buku ${brw.book_title} akan jatuh tempo dalam ${brw.days_remaining} hari. Segera kembalikan atau perpanjang.`
        },
        {
          type: 'reminder_due_soon',
          borrowing_id: brw.id,
          book_title: brw.book_title,
          days_remaining: brw.days_remaining,
          due_date: brw.tanggal_kembali
        }
      );
    }

    console.log(`Sent ${borrowings.length} due date reminders`);
  } catch (error) {
    console.error('Error in reminder job:', error);
  }
});
```

---

## 📱 Frontend Integration (Flutter)

### Handle Notification
```dart
// lib/app/services/fcm_service.dart
class FcmService {
  static Future<void> handleNotification(RemoteMessage message) async {
    final type = message.data['type'];
    
    switch (type) {
      case 'extension_approved':
        _handleExtensionApproved(message);
        break;
      case 'extension_denied':
        _handleExtensionDenied(message);
        break;
      case 'return_success':
        _handleReturnSuccess(message);
        break;
      // ... other cases
    }
  }
  
  static void _handleExtensionApproved(RemoteMessage message) {
    final borrowingId = int.parse(message.data['borrowing_id']);
    
    PerpanjanganOverlay.showApproved(
      message: message.notification?.body ?? 'Perpanjangan disetujui',
      onComplete: () {
        Get.toNamed('/detail-perpanjang', arguments: borrowingId);
      },
    );
  }
}
```

---

## 🧪 Testing

### Test Notification via Postman
```bash
POST https://fcm.googleapis.com/fcm/send
Headers:
  Authorization: key=YOUR_SERVER_KEY
  Content-Type: application/json

Body:
{
  "to": "USER_FCM_TOKEN",
  "notification": {
    "title": "Test Notification",
    "body": "This is a test"
  },
  "data": {
    "type": "test",
    "borrowing_id": "47"
  }
}
```

---

## 📊 Monitoring & Analytics

### Track Notification Metrics
```javascript
// Add to notification history
await db.query(`
  INSERT INTO notification_metrics 
  (user_id, type, sent_at, delivered, opened) 
  VALUES (?, ?, NOW(), ?, ?)
`, [userId, type, true, false]);

// Update when user opens notification
await db.query(`
  UPDATE notification_metrics 
  SET opened = TRUE, opened_at = NOW() 
  WHERE id = ?
`, [notificationId]);
```

---

## 🔐 Security

1. **Server Key**: Simpan di environment variable, jangan commit ke git
2. **Token Validation**: Validasi FCM token sebelum save ke database
3. **Rate Limiting**: Batasi jumlah notifikasi per user per hari
4. **User Preferences**: Izinkan user disable notifikasi tertentu

---

## 📝 Checklist Implementation

- [ ] Setup Firebase Admin SDK
- [ ] Create `fcm_tokens` table
- [ ] Create `notifications` table (optional)
- [ ] Implement FCM Service
- [ ] Add notification to extension approval
- [ ] Add notification to extension rejection
- [ ] Add notification to return confirmation
- [ ] Add notification to payment success
- [ ] Setup cron job for reminders
- [ ] Test all notification types
- [ ] Add notification preferences
- [ ] Monitor notification delivery rate

---

## 🚀 Deployment

1. Upload `firebase-service-account.json` ke server (jangan commit!)
2. Set environment variable `GOOGLE_APPLICATION_CREDENTIALS`
3. Install dependencies: `npm install firebase-admin`
4. Setup cron jobs
5. Test notification delivery
6. Monitor logs

---

**Created:** 2026-04-08  
**Version:** 1.0  
**Author:** Development Team
