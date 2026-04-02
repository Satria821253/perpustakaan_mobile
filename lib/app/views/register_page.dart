import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import 'widgets/logo_header.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _namaCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _teleponCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _konfirmasiCtrl = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureKonfirmasi = true;

  @override
  void dispose() {
    _namaCtrl.dispose();
    _emailCtrl.dispose();
    _teleponCtrl.dispose();
    _passwordCtrl.dispose();
    _konfirmasiCtrl.dispose();
    super.dispose();
  }

  Future<void> _doRegister() async {
    if (!_formKey.currentState!.validate()) return;
    try {
      await AuthController.to.register(
        email: _emailCtrl.text.trim(),
        password: _passwordCtrl.text,
        nama: _namaCtrl.text.trim(),
        noTelepon: _teleponCtrl.text.trim(),
      );
      Get.offNamed('/login');
      Get.snackbar(
        'Berhasil',
        'Akun berhasil dibuat, silakan login',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green[100],
        colorText: Colors.green[900],
        margin: const EdgeInsets.all(16),
      );
    } catch (e) {
      Get.snackbar(
        'Gagal',
        e.toString().replaceFirst('Exception: ', ''),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red[100],
        colorText: Colors.red[900],
        margin: const EdgeInsets.all(16),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              const LogoHeader(),
              const SizedBox(height: 24),
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _label('Nama Lengkap'),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _namaCtrl,
                      decoration: _inputDecoration(),
                      validator: (v) => (v == null || v.trim().isEmpty)
                          ? 'Wajib diisi'
                          : null,
                    ),
                    const SizedBox(height: 16),
                    _label('Email'),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _emailCtrl,
                      keyboardType: TextInputType.emailAddress,
                      decoration: _inputDecoration(),
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) return 'Wajib diisi';
                        if (!v.contains('@')) return 'Email tidak valid';
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    _label('No. Telepon'),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _teleponCtrl,
                      keyboardType: TextInputType.phone,
                      decoration: _inputDecoration(),
                      validator: (v) => (v == null || v.trim().isEmpty)
                          ? 'Wajib diisi'
                          : null,
                    ),
                    const SizedBox(height: 16),
                    _label('Password'),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _passwordCtrl,
                      obscureText: _obscurePassword,
                      decoration: _inputDecoration().copyWith(
                        suffixIcon: _eyeIcon(_obscurePassword,
                            () => setState(() => _obscurePassword = !_obscurePassword)),
                      ),
                      validator: (v) {
                        if (v == null || v.isEmpty) return 'Wajib diisi';
                        if (v.length < 6) return 'Minimal 6 karakter';
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    _label('Konfirmasi Password'),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _konfirmasiCtrl,
                      obscureText: _obscureKonfirmasi,
                      decoration: _inputDecoration().copyWith(
                        suffixIcon: _eyeIcon(_obscureKonfirmasi,
                            () => setState(() => _obscureKonfirmasi = !_obscureKonfirmasi)),
                      ),
                      validator: (v) {
                        if (v == null || v.isEmpty) return 'Wajib diisi';
                        if (v != _passwordCtrl.text) return 'Password tidak cocok';
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),
                    Obx(() => SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFF1565C0), Color(0xFF42A5F5)],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: ElevatedButton(
                              onPressed: AuthController.to.isLoading.value
                                  ? null
                                  : _doRegister,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                              ),
                              child: AuthController.to.isLoading.value
                                  ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                          color: Colors.white, strokeWidth: 2),
                                    )
                                  : const Text('Daftar',
                                      style: TextStyle(
                                          fontFamily: 'Poppins',
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500)),
                            ),
                          ),
                        )),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              Center(
                child: GestureDetector(
                  onTap: () => Get.offNamed('/login'),
                  child: const Text('Sudah Punya Akun? Login',
                      style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 14,
                          color: Color(0xFF2962FF))),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _label(String text) => Text(
        text,
        style: const TextStyle(
            fontFamily: 'Poppins', fontSize: 14, color: Colors.black87),
      );

  Widget _eyeIcon(bool obscure, VoidCallback onTap) => IconButton(
        icon: Icon(
          obscure
              ? Icons.remove_red_eye_outlined
              : Icons.visibility_off_outlined,
          color: Colors.grey[500],
          size: 20,
        ),
        onPressed: onTap,
      );

  InputDecoration _inputDecoration() => InputDecoration(
        isDense: true,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Color(0xFFCCCCCC))),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Color(0xFFCCCCCC))),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide:
                const BorderSide(color: Color(0xFF2962FF), width: 1.5)),
        errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Colors.red)),
      );
}
