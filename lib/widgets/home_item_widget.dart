import 'package:flutter/material.dart';

class HomeItemWidget extends StatelessWidget {
  const HomeItemWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            'https://picsum.photos/200',
            width: double.infinity,
            height: 130,
            fit: BoxFit.cover,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return const SizedBox(
                width: double.infinity,
                height: 130,
                child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
              );
            },
            errorBuilder: (context, error, stackTrace) => Container(
              width: double.infinity,
              height: 130,
              color: Colors.grey,
              child: const Icon(Icons.person, color: Colors.white),
            ),
          ),
        ),
        SizedBox(height: 12),
        Text(
          'Meja Makan Kayu Jati - Ukuran besar 100m2',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(fontSize: 14),
        ),
        SizedBox(height: 8),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Rp 3.400.000',
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
            SizedBox(width: 8),
            Container(
              color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
              padding: EdgeInsets.symmetric(vertical: 2, horizontal: 6),
              child: Text(
                '-12%',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).primaryColor,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 4),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(Icons.star_rounded, color: Color(0xFFFFB700), size: 16),
            SizedBox(width: 0.5),
            Text('4.9', style: TextStyle(fontSize: 12)),
            SizedBox(width: 20),
            Text('121 Terjual', style: TextStyle(fontSize: 12)),
          ],
        ),
      ],
    );
  }
}
