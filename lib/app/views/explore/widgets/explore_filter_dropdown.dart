import 'package:ei_books/app/controllers/explore_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class ExploreFilterDropdown extends StatelessWidget {
  final ExploreController ctrl;
  const ExploreFilterDropdown({super.key, required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: MediaQuery.of(context).padding.top + 62,
      right: 20,
      child: Material(
        elevation: 12,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          width: 220,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Text('Urutkan',
                    style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                        fontFamily: 'Poppins')),
              ),
              ...ctrl.sortOptions.map((s) => Obx(() => InkWell(
                    onTap: () => ctrl.setSort(s['value']!),
                    borderRadius: BorderRadius.circular(10),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 10),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(s['label']!,
                                style: const TextStyle(
                                    fontSize: 13, fontFamily: 'Poppins')),
                          ),
                          if (ctrl.selectedSort.value == s['value'])
                            const Icon(Icons.check_rounded,
                                color: Color(0xFF1565C0), size: 18),
                        ],
                      ),
                    ),
                  ))),
            ],
          ),
        ),
      ),
    );
  }
}
