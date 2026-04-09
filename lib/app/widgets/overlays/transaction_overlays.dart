import 'package:flutter/material.dart';
import 'animation_overlay.dart';

/// Overlay untuk Peminjaman
class PeminjamanOverlay {
  /// Peminjaman disetujui
  static void showApproved({
    String? message,
    VoidCallback? onComplete,
  }) {
    AnimationOverlay.showApproved(
      title: 'Peminjaman Disetujui!',
      message: message ?? 'Buku berhasil dipinjam. Silakan ambil di perpustakaan.',
      onComplete: onComplete,
    );
  }

  /// Peminjaman ditolak
  static void showDenied({
    String? message,
    VoidCallback? onComplete,
  }) {
    AnimationOverlay.showDenied(
      title: 'Peminjaman Ditolak',
      message: message ?? 'Maaf, peminjaman Anda tidak dapat diproses.',
      onComplete: onComplete,
    );
  }
}

/// Overlay untuk Pengembalian
class PengembalianOverlay {
  /// Pengembalian berhasil
  static void showSuccess({
    String? message,
    VoidCallback? onComplete,
  }) {
    AnimationOverlay.showSuccess(
      title: 'Pengembalian Berhasil!',
      message: message ?? 'Buku telah berhasil dikembalikan. Terima kasih!',
      onComplete: onComplete,
    );
  }

  /// Pengembalian ditolak
  static void showDenied({
    String? message,
    VoidCallback? onComplete,
  }) {
    AnimationOverlay.showDenied(
      title: 'Pengembalian Ditolak',
      message: message ?? 'Maaf, pengembalian tidak dapat diproses.',
      onComplete: onComplete,
    );
  }
}

/// Overlay untuk Perpanjangan
class PerpanjanganOverlay {
  /// Perpanjangan disetujui
  static void showApproved({
    String? message,
    VoidCallback? onComplete,
  }) {
    AnimationOverlay.showApproved(
      title: 'Perpanjangan Disetujui!',
      message: message ?? 'Masa peminjaman berhasil diperpanjang.',
      onComplete: onComplete,
    );
  }

  /// Perpanjangan ditolak
  static void showDenied({
    String? message,
    VoidCallback? onComplete,
  }) {
    AnimationOverlay.showDenied(
      title: 'Perpanjangan Ditolak',
      message: message ?? 'Maaf, perpanjangan tidak dapat diproses.',
      onComplete: onComplete,
    );
  }
}

/// Overlay untuk Pembayaran
class PembayaranOverlay {
  /// Pembayaran berhasil
  static void showSuccess({
    String? message,
    VoidCallback? onComplete,
  }) {
    AnimationOverlay.showSuccess(
      title: 'Pembayaran Berhasil!',
      message: message ?? 'Transaksi pembayaran telah berhasil diproses.',
      onComplete: onComplete,
    );
  }

  /// Pembayaran gagal
  static void showError({
    String? message,
    VoidCallback? onComplete,
  }) {
    AnimationOverlay.showError(
      title: 'Pembayaran Gagal',
      message: message ?? 'Maaf, pembayaran tidak dapat diproses. Silakan coba lagi.',
      onComplete: onComplete,
    );
  }

  /// Pembayaran pending (untuk payment gateway)
  static void showPending({
    String? message,
    VoidCallback? onComplete,
  }) {
    AnimationOverlay.show(
      type: AnimationType.loading,
      title: 'Menunggu Pembayaran',
      message: message ?? 'Silakan selesaikan pembayaran di aplikasi payment gateway.',
      onComplete: onComplete,
      duration: const Duration(seconds: 2),
    );
  }
}

/// Overlay untuk Reservasi
class ReservasiOverlay {
  /// Reservasi berhasil
  static void showSuccess({
    String? message,
    VoidCallback? onComplete,
  }) {
    AnimationOverlay.showSuccess(
      title: 'Reservasi Berhasil!',
      message: message ?? 'Buku berhasil direservasi. Silakan ambil sesuai jadwal.',
      onComplete: onComplete,
    );
  }

  /// Reservasi dibatalkan
  static void showCancelled({
    String? message,
    VoidCallback? onComplete,
  }) {
    AnimationOverlay.showDenied(
      title: 'Reservasi Dibatalkan',
      message: message ?? 'Reservasi buku telah dibatalkan.',
      onComplete: onComplete,
    );
  }

  /// Reservasi pending - menunggu konfirmasi petugas
  static void showPending({
    String? message,
    VoidCallback? onComplete,
  }) {
    AnimationOverlay.show(
      type: AnimationType.loading,
      title: 'Kode Berhasil Dibuat',
      message: message ?? 'Generate kode berhasil\nMenunggu konfirmasi petugas...',
      onComplete: onComplete,
      duration: const Duration(seconds: 5),
    );
  }
}
