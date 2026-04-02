import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/profile_controller.dart';
import '../../controllers/auth_controller.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late final TextEditingController _namaCtrl;
  late final TextEditingController _teleponCtrl;
  final _loading = false.obs;

  @override
  void initState() {
    super.initState();
    final user = AuthController.to.user.value;
    _namaCtrl = TextEditingController(text: user?.nama ?? '');
    _teleponCtrl = TextEditingController(text: user?.noTelepon ?? '');
  }

  @override
  void dispose() {
    _namaCtrl.dispose();
    _teleponCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_namaCtrl.text.trim().isEmpty) {
      Get.snackbar('Error', 'Nama tidak boleh kosong', snackPosition: SnackPosition.BOTTOM);
      return;
    }
    _loading(true);
    try {
      await ProfileController.to.updateProfile(
        nama: _namaCtrl.text.trim(),
        noTelepon: _teleponCtrl.text.trim(),
      );
    } finally {
      _loading(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F2F5),
      appBar: AppBar(
        title: const Text('Edit Profile',
            style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w700, fontSize: 16)),
        backgroundColor: const Color(0xFF1565C0),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _buildField('Nama Lengkap', _namaCtrl, Icons.person_outline),
            const SizedBox(height: 16),
            _buildField('No. Telepon', _teleponCtrl, Icons.phone_outlined,
                keyboardType: TextInputType.phone),
            const SizedBox(height: 28),
            Obx(() => SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _loading.value ? null : _submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1565C0),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: _loading.value
                        ? const SizedBox(
                            width: 20, height: 20,
                            child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                        : const Text('Simpan',
                            style: TextStyle(
                                fontFamily: 'Poppins', fontWeight: FontWeight.w600,
                                fontSize: 15, color: Colors.white)),
                  ),
                )),
          ],
        ),
      ),
    );
  }

  Widget _buildField(String label, TextEditingController ctrl, IconData icon,
      {TextInputType keyboardType = TextInputType.text}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
                fontSize: 13, fontWeight: FontWeight.w600,
                color: Colors.black87, fontFamily: 'Poppins')),
        const SizedBox(height: 8),
        TextField(
          controller: ctrl,
          keyboardType: keyboardType,
          style: const TextStyle(fontFamily: 'Poppins', fontSize: 14),
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: const Color(0xFF1565C0), size: 20),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey[300]!)),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey[300]!)),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFF1565C0))),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
        ),
      ],
    );
  }
}
