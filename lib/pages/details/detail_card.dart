import 'package:buhuiwangshi/pages/details/store.dart';
import 'package:buhuiwangshi/utils/colors.dart';
import 'package:buhuiwangshi/utils/date.dart';
import 'package:buhuiwangshi/utils/time.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DetailCard extends StatelessWidget {
  const DetailCard({super.key});

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<DetailsPageStore>(context);
    final data = store.data!;
    final color = Color(data.color);
    final bgColor = color.withOpacity(0.5);

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(32),
      ),
      margin: const EdgeInsets.fromLTRB(12, 0, 12, 0),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  data.typeIcon,
                  size: 32,
                  color: textColor,
                ),
                const SizedBox(width: 8),
                Text(
                  data.name,
                  style: const TextStyle(fontSize: 24, color: textColor),
                ),
              ],
            ),
            Row(
              children: [
                Text(
                  getDateText(data.time, isLocale: false),
                  style: const TextStyle(fontSize: 18, color: textColor),
                ),
                const SizedBox(width: 8),
                Text(
                  getTimeText(data.time),
                  style: const TextStyle(fontSize: 18, color: textColor),
                ),
              ],
            ),
            if (data.remark != "")
              Text(data.remark,
                  style: const TextStyle(fontSize: 18, color: textColor)),
          ],
        ),
      ),
    );
  }
}
