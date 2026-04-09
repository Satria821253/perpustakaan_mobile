# 🔧 Admin Panel Specification

## 📋 Overview

Dokumentasi ini menjelaskan spesifikasi backend untuk Admin Panel yang mencakup:
1. **Kelola Koin** - Manage koin user (top up, adjust, history)
2. **Kelola Anggota** - CRUD user/anggota perpustakaan
3. **Kelola Petugas** - CRUD petugas perpustakaan

---

## 🎯 Konversi Koin

**1 Koin = Rp 100**

| Rupiah | Koin |
|--------|------|
| Rp 1.000 | 10 koin |
| Rp 5.000 | 50 koin |
| Rp 10.000 | 100 koin |
| Rp 50.000 | 500 koin |

---

## 1️⃣ Kelola Koin

### 📊 Database Schema

#### Table: `koin_transactions`
```sql
CREATE TABLE koin_transactions (
  id INT PRIMARY KEY AUTO_INCREMENT,
  user_id INT NOT NULL,
  type ENUM('top_up', 'adjustment', 'reward', 'payment', 'refund') NOT NULL,
  amount INT NOT NULL COMMENT 'Jumlah koin (+ untuk tambah, - untuk kurang)',
  balance_before INT NOT NULL COMMENT 'Saldo sebelum transaksi',
  balance_after INT NOT NULL COMMENT 'Saldo setelah transaksi',
  description TEXT,
  reference_type VARCHAR(50) COMMENT 'borrowing, payment, challenge, etc',
  reference_id INT COMMENT 'ID dari reference',
  admin_id INT COMMENT 'ID admin yang melakukan transaksi',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  FOREIGN KEY (admin_id) REFERENCES users(id) ON DELETE SET NULL,
  INDEX idx_user_created (user_id, created_at),
  INDEX idx_type (type)
);
```

#### Update Table: `users`
```sql
ALTER TABLE users ADD COLUMN koin INT DEFAULT 0 COMMENT 'Saldo koin user';
ALTER TABLE users ADD INDEX idx_koin (koin);
```

---

### 🔌 API Endpoints - Kelola Koin

#### 1.1 Get User Koin Balance
```javascript
GET /api/admin/koin/balance/:userId
Headers: Authorization: Bearer {admin_token}

Response: {
  "success": true,
  "data": {
    "user_id": 18,
    "nama": "John Doe",
    "email": "john@example.com",
    "koin": 150,
    "last_transaction": "2026-04-08 10:30:00"
  }
}
```

---

#### 1.2 Top Up Koin
```javascript
POST /api/admin/koin/top-up
Headers: Authorization: Bearer {admin_token}
Body: {
  "user_id": 18,
  "amount": 100,
  "description": "Top up manual oleh admin"
}

Response: {
  "success": true,
  "message": "Top up berhasil",
  "data": {
    "transaction_id": 123,
    "user_id": 18,
    "amount": 100,
    "balance_before": 150,
    "balance_after": 250
  }
}
```

**Backend Logic:**
```javascript
async function topUpKoin(req, res) {
  const { user_id, amount, description } = req.body;
  const admin_id = req.user.id; // Dari JWT token
  
  try {
    // Start transaction
    await db.beginTransaction();
    
    // Get current balance
    const [user] = await db.query('SELECT koin FROM users WHERE id = ?', [user_id]);
    const balance_before = user[0].koin;
    const balance_after = balance_before + amount;
    
    // Update user balance
    await db.query('UPDATE users SET koin = ? WHERE id = ?', [balance_after, user_id]);
    
    // Insert transaction record
    const [result] = await db.query(`
      INSERT INTO koin_transactions 
      (user_id, type, amount, balance_before, balance_after, description, admin_id)
      VALUES (?, 'top_up', ?, ?, ?, ?, ?)
    `, [user_id, amount, balance_before, balance_after, description, admin_id]);
    
    await db.commit();
    
    res.json({
      success: true,
      message: 'Top up berhasil',
      data: {
        transaction_id: result.insertId,
        user_id,
        amount,
        balance_before,
        balance_after
      }
    });
  } catch (error) {
    await db.rollback();
    res.status(500).json({ error: 'Failed to top up koin' });
  }
}
```

---

#### 1.3 Adjust Koin (Tambah/Kurang)
```javascript
POST /api/admin/koin/adjust
Headers: Authorization: Bearer {admin_token}
Body: {
  "user_id": 18,
  "amount": -50,  // Negatif untuk kurangi, positif untuk tambah
  "description": "Koreksi saldo koin"
}

Response: {
  "success": true,
  "message": "Adjustment berhasil",
  "data": {
    "transaction_id": 124,
    "user_id": 18,
    "amount": -50,
    "balance_before": 250,
    "balance_after": 200
  }
}
```

---

#### 1.4 Get Koin Transaction History
```javascript
GET /api/admin/koin/history/:userId?page=1&limit=20
Headers: Authorization: Bearer {admin_token}

Response: {
  "success": true,
  "data": {
    "user": {
      "id": 18,
      "nama": "John Doe",
      "koin": 200
    },
    "transactions": [
      {
        "id": 124,
        "type": "adjustment",
        "amount": -50,
        "balance_before": 250,
        "balance_after": 200,
        "description": "Koreksi saldo koin",
        "admin_name": "Admin User",
        "created_at": "2026-04-08 11:00:00"
      },
      {
        "id": 123,
        "type": "top_up",
        "amount": 100,
        "balance_before": 150,
        "balance_after": 250,
        "description": "Top up manual oleh admin",
        "admin_name": "Admin User",
        "created_at": "2026-04-08 10:30:00"
      }
    ],
    "pagination": {
      "page": 1,
      "limit": 20,
      "total": 2,
      "total_pages": 1
    }
  }
}
```

---

#### 1.5 Get All Users Koin Summary
```javascript
GET /api/admin/koin/summary?page=1&limit=50&search=john
Headers: Authorization: Bearer {admin_token}

Response: {
  "success": true,
  "data": {
    "users": [
      {
        "id": 18,
        "nama": "John Doe",
        "email": "john@example.com",
        "koin": 200,
        "last_transaction": "2026-04-08 11:00:00",
        "total_top_up": 500,
        "total_spent": 300
      }
    ],
    "pagination": {
      "page": 1,
      "limit": 50,
      "total": 1,
      "total_pages": 1
    },
    "statistics": {
      "total_koin_in_system": 15000,
      "total_users_with_koin": 45,
      "average_koin_per_user": 333
    }
  }
}
```

---

## 2️⃣ Kelola Anggota

### 📊 Database Schema

#### Table: `users` (sudah ada, tambahan field)
```sql
ALTER TABLE users ADD COLUMN status ENUM('aktif', 'nonaktif', 'suspended') DEFAULT 'aktif';
ALTER TABLE users ADD COLUMN tanggal_daftar TIMESTAMP DEFAULT CURRENT_TIMESTAMP;
ALTER TABLE users ADD COLUMN tanggal_expired DATE COMMENT 'Tanggal keanggotaan expired';
ALTER TABLE users ADD COLUMN catatan_admin TEXT COMMENT 'Catatan dari admin';
ALTER TABLE users ADD INDEX idx_status (status);
```

---

### 🔌 API Endpoints - Kelola Anggota

#### 2.1 Get All Anggota
```javascript
GET /api/admin/anggota?page=1&limit=50&status=aktif&search=john
Headers: Authorization: Bearer {admin_token}

Response: {
  "success": true,
  "data": {
    "anggota": [
      {
        "id": 18,
        "nama": "John Doe",
        "email": "john@example.com",
        "no_telepon": "081234567890",
        "nomor_anggota": "A001234",
        "status": "aktif",
        "koin": 200,
        "tanggal_daftar": "2026-01-15",
        "tanggal_expired": "2027-01-15",
        "total_pinjam": 15,
        "sedang_pinjam": 2,
        "total_denda": 0
      }
    ],
    "pagination": {
      "page": 1,
      "limit": 50,
      "total": 1,
      "total_pages": 1
    },
    "statistics": {
      "total_anggota": 150,
      "aktif": 120,
      "nonaktif": 20,
      "suspended": 10
    }
  }
}
```

---

#### 2.2 Get Anggota Detail
```javascript
GET /api/admin/anggota/:id
Headers: Authorization: Bearer {admin_token}

Response: {
  "success": true,
  "data": {
    "user": {
      "id": 18,
      "nama": "John Doe",
      "email": "john@example.com",
      "no_telepon": "081234567890",
      "nomor_anggota": "A001234",
      "status": "aktif",
      "koin": 200,
      "tanggal_daftar": "2026-01-15",
      "tanggal_expired": "2027-01-15",
      "catatan_admin": "Anggota aktif, sering pinjam buku"
    },
    "statistics": {
      "total_pinjam": 15,
      "sedang_pinjam": 2,
      "total_denda": 0,
      "total_review": 8,
      "total_koin_earned": 500,
      "total_koin_spent": 300
    },
    "active_borrowings": [
      {
        "id": 47,
        "book_title": "Dilan",
        "tanggal_pinjam": "2026-04-01",
        "tanggal_kembali": "2026-04-29",
        "status": "dipinjam",
        "hari_tersisa": 21
      }
    ]
  }
}
```

---

#### 2.3 Create Anggota
```javascript
POST /api/admin/anggota
Headers: Authorization: Bearer {admin_token}
Body: {
  "nama": "Jane Smith",
  "email": "jane@example.com",
  "no_telepon": "081234567891",
  "password": "password123",
  "tanggal_expired": "2027-04-08",
  "catatan_admin": "Anggota baru dari sekolah"
}

Response: {
  "success": true,
  "message": "Anggota berhasil ditambahkan",
  "data": {
    "id": 151,
    "nama": "Jane Smith",
    "email": "jane@example.com",
    "nomor_anggota": "A001235",
    "status": "aktif"
  }
}
```

**Backend Logic:**
```javascript
async function createAnggota(req, res) {
  const { nama, email, no_telepon, password, tanggal_expired, catatan_admin } = req.body;
  
  try {
    // Generate nomor anggota
    const [lastUser] = await db.query(
      'SELECT nomor_anggota FROM users ORDER BY id DESC LIMIT 1'
    );
    const lastNumber = lastUser[0]?.nomor_anggota || 'A000000';
    const newNumber = 'A' + String(parseInt(lastNumber.substring(1)) + 1).padStart(6, '0');
    
    // Hash password
    const hashedPassword = await bcrypt.hash(password, 10);
    
    // Insert user
    const [result] = await db.query(`
      INSERT INTO users 
      (nama, email, no_telepon, password, nomor_anggota, role, status, tanggal_expired, catatan_admin)
      VALUES (?, ?, ?, ?, ?, 'user', 'aktif', ?, ?)
    `, [nama, email, no_telepon, hashedPassword, newNumber, tanggal_expired, catatan_admin]);
    
    res.json({
      success: true,
      message: 'Anggota berhasil ditambahkan',
      data: {
        id: result.insertId,
        nama,
        email,
        nomor_anggota: newNumber,
        status: 'aktif'
      }
    });
  } catch (error) {
    res.status(500).json({ error: 'Failed to create anggota' });
  }
}
```

---

#### 2.4 Update Anggota
```javascript
PUT /api/admin/anggota/:id
Headers: Authorization: Bearer {admin_token}
Body: {
  "nama": "John Doe Updated",
  "email": "john.updated@example.com",
  "no_telepon": "081234567890",
  "status": "aktif",
  "tanggal_expired": "2027-12-31",
  "catatan_admin": "Updated info"
}

Response: {
  "success": true,
  "message": "Anggota berhasil diupdate"
}
```

---

#### 2.5 Update Status Anggota
```javascript
PATCH /api/admin/anggota/:id/status
Headers: Authorization: Bearer {admin_token}
Body: {
  "status": "suspended",
  "alasan": "Terlambat mengembalikan buku lebih dari 30 hari"
}

Response: {
  "success": true,
  "message": "Status anggota berhasil diupdate"
}
```

---

#### 2.6 Delete Anggota
```javascript
DELETE /api/admin/anggota/:id
Headers: Authorization: Bearer {admin_token}

Response: {
  "success": true,
  "message": "Anggota berhasil dihapus"
}
```

**Note:** Soft delete recommended (update status menjadi 'deleted')

---

#### 2.7 Reset Password Anggota
```javascript
POST /api/admin/anggota/:id/reset-password
Headers: Authorization: Bearer {admin_token}
Body: {
  "new_password": "newpassword123"
}

Response: {
  "success": true,
  "message": "Password berhasil direset"
}
```

---

## 3️⃣ Kelola Petugas

### 📊 Database Schema

#### Table: `users` (role = 'petugas' atau 'admin')
```sql
-- Sudah ada di tabel users
-- role ENUM('user', 'petugas', 'admin')
```

#### Table: `petugas_permissions` (Optional - untuk granular permissions)
```sql
CREATE TABLE petugas_permissions (
  id INT PRIMARY KEY AUTO_INCREMENT,
  petugas_id INT NOT NULL,
  permission VARCHAR(50) NOT NULL COMMENT 'approve_borrowing, approve_extension, etc',
  granted_by INT COMMENT 'Admin yang memberikan permission',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (petugas_id) REFERENCES users(id) ON DELETE CASCADE,
  FOREIGN KEY (granted_by) REFERENCES users(id) ON DELETE SET NULL,
  UNIQUE KEY unique_petugas_permission (petugas_id, permission)
);
```

---

### 🔌 API Endpoints - Kelola Petugas

#### 3.1 Get All Petugas
```javascript
GET /api/admin/petugas?page=1&limit=50&status=aktif
Headers: Authorization: Bearer {admin_token}

Response: {
  "success": true,
  "data": {
    "petugas": [
      {
        "id": 5,
        "nama": "Petugas A",
        "email": "petugas.a@perpus.com",
        "no_telepon": "081234567892",
        "role": "petugas",
        "status": "aktif",
        "tanggal_daftar": "2026-01-01",
        "total_approved_borrowings": 150,
        "total_approved_extensions": 45,
        "total_confirmed_returns": 120
      }
    ],
    "pagination": {
      "page": 1,
      "limit": 50,
      "total": 1,
      "total_pages": 1
    }
  }
}
```

---

#### 3.2 Get Petugas Detail
```javascript
GET /api/admin/petugas/:id
Headers: Authorization: Bearer {admin_token}

Response: {
  "success": true,
  "data": {
    "petugas": {
      "id": 5,
      "nama": "Petugas A",
      "email": "petugas.a@perpus.com",
      "no_telepon": "081234567892",
      "role": "petugas",
      "status": "aktif",
      "tanggal_daftar": "2026-01-01"
    },
    "statistics": {
      "total_approved_borrowings": 150,
      "total_approved_extensions": 45,
      "total_confirmed_returns": 120,
      "total_rejected_borrowings": 5,
      "total_rejected_extensions": 3
    },
    "permissions": [
      "approve_borrowing",
      "approve_extension",
      "confirm_return",
      "manage_fines"
    ],
    "recent_activities": [
      {
        "action": "approve_extension",
        "description": "Menyetujui perpanjangan buku Dilan",
        "timestamp": "2026-04-08 10:30:00"
      }
    ]
  }
}
```

---

#### 3.3 Create Petugas
```javascript
POST /api/admin/petugas
Headers: Authorization: Bearer {admin_token}
Body: {
  "nama": "Petugas B",
  "email": "petugas.b@perpus.com",
  "no_telepon": "081234567893",
  "password": "petugas123",
  "role": "petugas",
  "permissions": [
    "approve_borrowing",
    "approve_extension",
    "confirm_return"
  ]
}

Response: {
  "success": true,
  "message": "Petugas berhasil ditambahkan",
  "data": {
    "id": 6,
    "nama": "Petugas B",
    "email": "petugas.b@perpus.com",
    "role": "petugas"
  }
}
```

---

#### 3.4 Update Petugas
```javascript
PUT /api/admin/petugas/:id
Headers: Authorization: Bearer {admin_token}
Body: {
  "nama": "Petugas A Updated",
  "email": "petugas.a.updated@perpus.com",
  "no_telepon": "081234567892",
  "status": "aktif"
}

Response: {
  "success": true,
  "message": "Petugas berhasil diupdate"
}
```

---

#### 3.5 Update Petugas Permissions
```javascript
PUT /api/admin/petugas/:id/permissions
Headers: Authorization: Bearer {admin_token}
Body: {
  "permissions": [
    "approve_borrowing",
    "approve_extension",
    "confirm_return",
    "manage_fines"
  ]
}

Response: {
  "success": true,
  "message": "Permissions berhasil diupdate"
}
```

---

#### 3.6 Delete Petugas
```javascript
DELETE /api/admin/petugas/:id
Headers: Authorization: Bearer {admin_token}

Response: {
  "success": true,
  "message": "Petugas berhasil dihapus"
}
```

---

## 🔐 Authorization & Permissions

### Middleware: Check Admin Role
```javascript
function isAdmin(req, res, next) {
  if (req.user.role !== 'admin') {
    return res.status(403).json({ error: 'Forbidden: Admin only' });
  }
  next();
}

// Usage
app.get('/api/admin/koin/summary', authenticate, isAdmin, getKoinSummary);
```

### Middleware: Check Petugas Permission
```javascript
function hasPermission(permission) {
  return async (req, res, next) => {
    if (req.user.role === 'admin') {
      return next(); // Admin has all permissions
    }
    
    if (req.user.role !== 'petugas') {
      return res.status(403).json({ error: 'Forbidden' });
    }
    
    const [perms] = await db.query(
      'SELECT * FROM petugas_permissions WHERE petugas_id = ? AND permission = ?',
      [req.user.id, permission]
    );
    
    if (perms.length === 0) {
      return res.status(403).json({ error: 'Permission denied' });
    }
    
    next();
  };
}

// Usage
app.post('/api/borrowings/approve', authenticate, hasPermission('approve_borrowing'), approveBorrowing);
```

---

## 📊 Dashboard Statistics

### Get Admin Dashboard Stats
```javascript
GET /api/admin/dashboard/stats
Headers: Authorization: Bearer {admin_token}

Response: {
  "success": true,
  "data": {
    "koin": {
      "total_in_system": 15000,
      "total_top_up_today": 500,
      "total_spent_today": 200
    },
    "anggota": {
      "total": 150,
      "aktif": 120,
      "nonaktif": 20,
      "suspended": 10,
      "new_today": 3
    },
    "petugas": {
      "total": 5,
      "aktif": 5,
      "nonaktif": 0
    },
    "borrowings": {
      "pending_approval": 8,
      "active": 45,
      "overdue": 3
    },
    "extensions": {
      "pending_approval": 5
    }
  }
}
```

---

## 🧪 Testing

### Test Scenarios

#### Kelola Koin:
- [ ] Top up koin ke user
- [ ] Adjust koin (tambah/kurang)
- [ ] View transaction history
- [ ] View koin summary all users

#### Kelola Anggota:
- [ ] Create new anggota
- [ ] Update anggota info
- [ ] Change anggota status
- [ ] Delete anggota
- [ ] Reset password anggota
- [ ] View anggota detail with statistics

#### Kelola Petugas:
- [ ] Create new petugas
- [ ] Update petugas info
- [ ] Update petugas permissions
- [ ] Delete petugas
- [ ] View petugas statistics

---

## 📝 Notes

1. **Soft Delete**: Recommended untuk anggota dan petugas (update status instead of DELETE)
2. **Audit Log**: Semua action admin harus tercatat (who, what, when)
3. **Validation**: Validate semua input (email format, phone number, etc)
4. **Transaction**: Gunakan database transaction untuk operasi koin
5. **Notification**: Kirim notifikasi ke user saat koin di-top up atau adjust

---

## 🚀 Implementation Priority

### Phase 1 (High Priority):
1. ✅ Kelola Koin - Top up & History
2. ✅ Kelola Anggota - CRUD basic

### Phase 2 (Medium Priority):
3. ✅ Kelola Petugas - CRUD basic
4. ✅ Dashboard Statistics

### Phase 3 (Low Priority):
5. ⚠️ Granular Permissions
6. ⚠️ Audit Log Detail
7. ⚠️ Export Reports

---

**Created:** 2026-04-08  
**Version:** 1.0  
**Author:** Development Team
