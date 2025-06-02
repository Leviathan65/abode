import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:abodes/accountpage.dart';
// TODO: Import your SignInPage here when it's ready
// import 'package:abodes/signinpage.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: 412.w,
        height: 917.h,
        child: Stack(
          children: const [
            _Background(),
            _BlueRoundedContainer(),
            _TitleText(),
            _DescriptionText(),
            _GetStartedButton(),
            _SignInText(),
          ],
        ),
      ),
    );
  }
}

class _Background extends StatelessWidget {
  const _Background({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(color: Colors.white);
  }
}

class _BlueRoundedContainer extends StatelessWidget {
  const _BlueRoundedContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 0.w,
      top: 437.h,
      width: 418.w,
      height: 523.h,
      child: Container(
        decoration: BoxDecoration(
          color: const Color.fromRGBO(21, 9, 91, 0.9),
          borderRadius: BorderRadius.circular(35),
        ),
      ),
    );
  }
}

class _TitleText extends StatelessWidget {
  const _TitleText({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: (412 - 389) / 2 + 0.5.w,
      top: 479.h,
      width: 389.w,
      height: 96.h,
      child: Text(
        'Find or Manage Verified Accommodation Easily',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontFamily: 'M PLUS 1p',
          fontWeight: FontWeight.w700,
          fontSize: 32.sp,
          height: 48 / 32,
          color: Colors.white,
          decoration: TextDecoration.none,
        ),
      ),
    );
  }
}

class _DescriptionText extends StatelessWidget {
  const _DescriptionText({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 13.w,
      top: 605.h,
      width: 384.w,
      height: 66.h,
      child: Text(
        'ABoDES can make your searching for verified housing (apartment, boarding houses, transient, and others) more accessible and easy in the tap of your hand.',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontFamily: 'M PLUS 1p',
          fontWeight: FontWeight.w400,
          fontSize: 15.sp,
          height: 22 / 15,
          color: Colors.white,
          decoration: TextDecoration.none,
        ),
      ),
    );
  }
}

class _GetStartedButton extends StatelessWidget {
  const _GetStartedButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 35.w,
      top: 701.h,
      width: 339.w,
      height: 62.h,
      child: InkWell(
        borderRadius: BorderRadius.circular(50),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const CreateAccountPage(),
            ),
          );
        },
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFFD9D9D9),
            borderRadius: BorderRadius.circular(50),
          ),
          alignment: Alignment.center,
          child: Text(
            'Find Your New Place',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'M PLUS 1p',
              fontWeight: FontWeight.w400,
              fontSize: 22.sp,
              height: 33 / 22,
              color: Colors.black,
              decoration: TextDecoration.none,
            ),
          ),
        ),
      ),
    );
  }
}

class _SignInText extends StatelessWidget {
  const _SignInText({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 33.w,
      top: 793.h,
      width: 350.w,
      height: 33.h,
      child: InkWell(
        onTap: () {
          // TODO: Replace with actual SignInPage navigation
          // Navigator.push(context, MaterialPageRoute(builder: (_) => const SignInPage()));
        },
        child: Text(
          'Already have an account? Sign In',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'M PLUS 1p',
            fontWeight: FontWeight.w400,
            fontSize: 22.sp,
            height: 33 / 22,
            color: Colors.white,
            decoration: TextDecoration.none,
          ),
        ),
      ),
    );
  }
}
