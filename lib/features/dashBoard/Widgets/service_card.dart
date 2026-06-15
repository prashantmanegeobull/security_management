import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ServiceCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color color;
  final String route;

  const ServiceCard({
    super.key,
    required this.icon,
    required this.title,
    required this.color,
    required this.route,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(22),
      onTap: () => Get.toNamed(route),

      child: Container(
        padding: const EdgeInsets.all(16),

        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.15),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),

        child: Column(
          crossAxisAlignment:
          CrossAxisAlignment.start,
          children: [

            Container(
              height: 50,
              width: 50,

              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius:
                BorderRadius.circular(15),
              ),

              child: Icon(
                icon,
                color: color,
                size: 28,
              ),
            ),

            const Spacer(),

            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),

            const SizedBox(height: 6),

            Row(
              children: [
                Text(
                  "Open",
                  style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 4),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 14,
                  color: color,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}