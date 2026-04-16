import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/cerpen_controller.dart';
import 'new_cerpen_card.dart';

class NewlyAddedSection extends StatelessWidget {
  const NewlyAddedSection({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<CerpenController>();
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Cerpen Terbaru',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                fontFamily: 'Poppins',
              ),
            ),
          ),
          const SizedBox(height: 12),
          Obx(() {
            if (ctrl.isLoadingNew.value) {
              return const SizedBox(
                height: 165,
                child: Center(child: CircularProgressIndicator()),
              );
            }
            if (ctrl.newCerpen.isEmpty) {
              return const SizedBox(
                height: 165,
                child: Center(
                  child: Text(
                    'Tidak ada cerpen terbaru',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              );
            }
            return SizedBox(
              height: 165,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: ctrl.newCerpen.length,
                itemBuilder: (context, i) => Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: NewCerpenCard(cerpen: ctrl.newCerpen[i]),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
