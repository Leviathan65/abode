import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:abodesv1/config/firebase/firebase_service.dart';
import 'package:go_router/go_router.dart';

class SignupPage extends StatefulWidget {
  final String role;

  const SignupPage({super.key, required this.role});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _middleNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _agreeTerms = false;
  bool _obscurePassword = true;
  bool _isLoading = false;

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _lastNameController.dispose();
    _firstNameController.dispose();
    _middleNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  bool _isValidEmail(String email) {
    final emailRegex = RegExp(
      r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$",
    );
    return emailRegex.hasMatch(email.trim());
  }


  bool _isStrongPassword(String password) {
    final passwordRegex = RegExp(r'^(?=.*[A-Z])(?=.*\d).{6,}$');
    return passwordRegex.hasMatch(password);
  }



  Future<void> _handleSignUp() async {
    if (_lastNameController.text.isEmpty ||
        _firstNameController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all required fields')),
      );
      return;
    }

    if (!_isValidEmail(_emailController.text.trim())) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid email address')),
      );
      return;
    }

    if (!_isStrongPassword(_passwordController.text.trim())) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text(
                'Password must be at least 6 characters, include an uppercase letter and a number')),
      );
      return;
    }

    if (!_agreeTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You must agree to the Terms and Conditions')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      final uid = credential.user!.uid;

      await FirebaseService().storeUserProfile(
        uid: uid,
        email: _emailController.text.trim(),
        firstName: _firstNameController.text.trim(),
        lastName: _lastNameController.text.trim(),
        middleName: _middleNameController.text.trim(),
        role: widget.role,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Sign-up successful!')),
      );

      Future.delayed(const Duration(seconds: 1), () {
        if (!mounted) return;

            context.push('/signin');
          },
        );

    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? 'Sign-up failed')),
      );
    } catch (e) {
      debugPrint('Sign-up error: \$e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Sign-up failed')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      border: InputBorder.none,
      hintText: hint,
      hintStyle: TextStyle(fontSize: 14.sp, color: Colors.black54),
    );
  }

  Widget _buildNameField(String label, TextEditingController controller) {
    return Container(
      margin: EdgeInsets.only(bottom: 10.h),
      height: 40.h,
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(90.r),
      ),
      alignment: Alignment.centerLeft,
      child: TextField(
        controller: controller,
        style: TextStyle(fontSize: 14.sp, color: Colors.black),
        decoration: _inputDecoration(label),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScreenUtilInit(
        designSize: const Size(412, 917),
        builder: (context, child) => SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Create Account',
                  style: TextStyle(
                    fontFamily: 'M PLUS 1p',
                    fontWeight: FontWeight.w700,
                    fontSize: 40.sp,
                    height: 59 / 40,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 8.h),
                SizedBox(
                  width: 320.w,
                  child: Text(
                    'Hi new here, please fill your information below to create your account',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontFamily: 'M PLUS 1p',
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                      height: 21 / 14,
                      color: Colors.black,
                    ),
                  ),
                ),
    SizedBox(height: 24.h),
    Container(
    width: double.infinity,
    padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
    decoration: BoxDecoration(
    color: const Color.fromRGBO(21, 9, 91, 0.9),
    borderRadius: BorderRadius.circular(35.r),
    ),
    child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
    Text('Name',
    style: TextStyle(
    color: Colors.white,
    fontSize: 16.sp,
    fontWeight: FontWeight.bold,
    )),
    SizedBox(height: 8.h),
    _buildNameField('Last Name', _lastNameController),
    _buildNameField('First Name', _firstNameController),
    _buildNameField('Middle Name (optional)', _middleNameController),
    SizedBox(height: 12.h),
    Text('Email',
    style: TextStyle(
    color: Colors.white,
    fontSize: 16.sp,
    fontWeight: FontWeight.bold,
    )),
    SizedBox(height: 8.h),
    Container(
    height: 40.h,
    decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(90.r),
    ),
    padding: EdgeInsets.symmetric(horizontal: 20.w),
    child: TextField(
    controller: _emailController,
    style: TextStyle(fontSize: 14.sp, color: Colors.black),
    decoration: _inputDecoration('Enter your email'),
    keyboardType: TextInputType.emailAddress,
    ),
    ),
    SizedBox(height: 15.h),
    Text('Password',
    style: TextStyle(
    color: Colors.white,
    fontSize: 16.sp,
    fontWeight: FontWeight.bold,
    )),
    SizedBox(height: 8.h),
    Container(
    height: 40.h,
    decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(90.r),
    ),
    padding: EdgeInsets.symmetric(horizontal: 20.w),
    child: Row(
    children: [
    Expanded(
    child: TextField(
    controller: _passwordController,
    obscureText: _obscurePassword,
    style: TextStyle(fontSize: 14.sp, color: Colors.black),
    decoration: _inputDecoration('Enter your password'),
    ),
    ),
    GestureDetector(
    onTap: () => setState(() {
    _obscurePassword = !_obscurePassword;
    }),
    child: Icon(
    _obscurePassword
    ? CupertinoIcons.eye_slash
        : CupertinoIcons.eye,
    color: Colors.grey,
    size: 22.w,
    ),
    ),
    ],
    ),
    ),
    SizedBox(height: 15.h),
    Row(
    children: [
    Checkbox(
    value: _agreeTerms,
    onChanged: (value) =>
    setState(() => _agreeTerms = value ?? false),
    activeColor: Colors.deepPurple.shade700,
    checkColor: Colors.white,
    ),
    SizedBox(width: 5.w),
    Expanded(
    child: Text(
    'Agree with Terms and Conditions',
    style: TextStyle(fontSize: 14.sp, color: Colors.white),
    ),
    ),
    ],
    ),
    SizedBox(height: 15.h),
    Center(
    child: SizedBox(
    width: 275.w,
    height: 45.h,
    child: ElevatedButton(
    onPressed: _agreeTerms && !_isLoading ? _handleSignUp : null,
    style: ElevatedButton.styleFrom(
    backgroundColor:
    _agreeTerms && !_isLoading ? Colors.white : Colors.grey,
    shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(50.r),
    ),
    ),
    child: _isLoading
    ? CircularProgressIndicator(
    color: const Color.fromRGBO(21, 9, 91, 0.9),
    )
        : Text(
    'Create Account',
    style: TextStyle(
    fontFamily: 'M PLUS 1p',
    fontWeight: FontWeight.w700,
    fontSize: 18.sp,
    color: const Color.fromRGBO(21, 9, 91, 0.9),
    ),
    ),
    ),
    ),
    ),
    ],
    ),
    ),
    SizedBox(height: 32.h),
    Text('Or sign in with',
    style: TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.w600,
    color: Colors.black,
    )),
    SizedBox(height: 16.h),
    Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
    IconButton(
    icon: Icon(CupertinoIcons.person_2_fill
        , size: 40.w),
    onPressed: () {
    // Placeholder for Facebook login
    },
    ),
    SizedBox(width: 30.w),
    IconButton(
    icon: Icon(CupertinoIcons.mail_solid, size: 40.w),
    onPressed: () {
    // Placeholder for Google login
    },
    ),
    ],
    ),
    SizedBox(height: 20.h),
    Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
    Text(
    'Already have an account? ',
    style: TextStyle(
    fontFamily: 'M PLUS 1p',
    fontWeight: FontWeight.w400,
    fontSize: 14.sp,
    ),
    ),
    GestureDetector(
    onTap: () {

    context.go('/signin');
    },
    child: Text(
    'Sign in',
    style: TextStyle(
    fontFamily: 'M PLUS 1p',
    fontWeight: FontWeight.w700,
    fontSize: 14.sp,
    color: const Color.fromRGBO(21, 9, 91, 0.9),
    ), ) )// ... no structural changes below this point
              ],
            ),]
          ),
        ),
      ),)
    );
  }
}
