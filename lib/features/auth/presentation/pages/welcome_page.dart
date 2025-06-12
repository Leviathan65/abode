import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:abodesv1/shared/constants/dimens.dart';
import 'package:abodesv1/shared/themes/text_styles.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: 1.sw,
        height: 1.sh,
        child: Stack(
          children: [
            _BlueRoundedBackground(),
            _WelcomeContent(),
          ],
        ),
      ),
    );
  }
}

class _BlueRoundedBackground extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 437.h,
      left: 0,
      right: 0,
      child: Container(
        height: 523.h,
        decoration: BoxDecoration(
          color: const Color.fromRGBO(21, 9, 91, 0.9),
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(35.r),
          ),
        ),
      ),
    );
  }
}

class _WelcomeContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: Dimens.screenPadding),
      child: Column(
        children: [
          const Spacer(flex: 8),
          Text(
            'Find or Manage Verified Accommodation Easily',
            textAlign: TextAlign.center,
            style: TextStyles.welcomeTitle,

          ),
          SizedBox(height: Dimens.titleSpacing),
          Text(
            'ABoDES can make your searching for verified housing (apartment, boarding houses, transient, and others) more accessible and easy in the tap of your hand.',
            textAlign: TextAlign.center,
            style: TextStyles.welcomeDescription,
          ),
          const Spacer(flex: 2),
          SizedBox(
            width: double.infinity,
            height: Dimens.buttonHeight,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFD9D9D9),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(Dimens.buttonRadius),
                ),
              ),
              onPressed: () => context.go('/create-account'),
              child: Text(
                'Find Your New Place',
                style: TextStyles.buttonText,
              ),
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}
