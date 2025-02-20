import 'package:flutter/widgets.dart';

class PromotionBannerWidget extends StatelessWidget {
  const PromotionBannerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Image.asset(
        'assets/CollectCoupon.png',
        width: 250,
        height: 250,
      ),
    );
  }
}
