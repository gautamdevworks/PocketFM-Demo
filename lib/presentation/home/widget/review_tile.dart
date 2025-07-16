import 'package:flutter/material.dart';
import 'package:pocket_fm_demo/model/product_model.dart';

class ReviewTile extends StatelessWidget {
  final Review review;
  const ReviewTile({super.key, required this.review});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: CircleAvatar(child: Text(review.reviewerName[0])),
      title: Text(review.reviewerName),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.star, color: Colors.amber, size: 16),
              const SizedBox(width: 4),
              Text(review.rating.toString()),
            ],
          ),
          Text(review.comment),
        ],
      ),
    );
  }
}
