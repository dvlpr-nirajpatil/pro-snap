import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:prosnap/core/consts/colours.dart';
import 'package:prosnap/core/consts/fonts.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class VerifiedSubscriptionScreen extends StatefulWidget {
  const VerifiedSubscriptionScreen({super.key});

  @override
  State<VerifiedSubscriptionScreen> createState() =>
      _VerifiedSubscriptionScreenState();
}

class _VerifiedSubscriptionScreenState extends State<VerifiedSubscriptionScreen>
    with SingleTickerProviderStateMixin {
  late final Razorpay _razorpay;
  late final AnimationController _successAnimationController;
  late final Animation<double> _successScaleAnimation;

  int _selectedAmount = 2999;
  String _selectedPlanTitle = "Annual";
  bool _isProcessingPayment = false;

  Widget verticalSpace(double height) => SizedBox(height: height.h);

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _successAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _successScaleAnimation = CurvedAnimation(
      parent: _successAnimationController,
      curve: Curves.elasticOut,
    );

    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose() {
    _razorpay.clear();
    _successAnimationController.dispose();
    super.dispose();
  }

  void createPayment(int amount) {
    setState(() {
      _isProcessingPayment = true;
    });

    final options = {
      'key': 'rzp_test_RJLx4xAV8HGFCq',
      'amount': amount * 100,
      'name': 'ProSnap Verified',
      'description': '$_selectedPlanTitle verified subscription',
      'prefill': {'contact': '8888888888', 'email': 'test@razorpay.com'},
      'external': {
        'wallets': ['paytm', 'phonepe', 'amazonpay'],
      },
    };

    try {
      _razorpay.open(options);
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _isProcessingPayment = false;
      });
      _showGenericFailureDialog();
    }
  }

  Future<void> _handlePaymentSuccess(PaymentSuccessResponse response) async {
    if (!mounted) return;

    setState(() {
      _isProcessingPayment = false;
    });

    await _showSuccessDialog(response.paymentId);
  }

  Future<void> _handlePaymentError(PaymentFailureResponse response) async {
    if (!mounted) return;

    setState(() {
      _isProcessingPayment = false;
    });

    await _showPaymentFailedDialog(response);
  }

  Future<void> _handleExternalWallet(ExternalWalletResponse response) async {
    if (!mounted) return;

    setState(() {
      _isProcessingPayment = false;
    });

    await _showExternalWalletSheet(response.walletName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colours.primary,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 18.h),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Icon(
                      Icons.arrow_back_ios_new,
                      color: Colours.white,
                      size: 18.sp,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    "Verified",
                    style: TextStyle(
                      fontFamily: Fonts.bold,
                      fontSize: 18.sp,
                      letterSpacing: 2,
                      color: Colours.white,
                    ),
                  ),
                  const Spacer(),
                  SizedBox(width: 18.w),
                ],
              ),
            ),
            Divider(color: Colours.divider, thickness: 0.5),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeroCard(),
                    verticalSpace(24),
                    Text(
                      "What you get",
                      style: TextStyle(
                        fontFamily: Fonts.semiBold,
                        fontSize: 16.sp,
                        color: Colours.white,
                      ),
                    ),
                    verticalSpace(14),
                    _buildFeatureTile(
                      icon: Icons.verified_rounded,
                      title: "Verified badge",
                      subtitle:
                          "Stand out with a blue check beside your name across the app.",
                    ),
                    _buildFeatureTile(
                      icon: Icons.support_agent,
                      title: "Priority support",
                      subtitle:
                          "Get faster account help when you need profile or safety support.",
                    ),
                    _buildFeatureTile(
                      icon: Icons.visibility_outlined,
                      title: "Stronger trust signals",
                      subtitle:
                          "Show your audience that your account is confirmed and authentic.",
                    ),
                    verticalSpace(26),
                    Text(
                      "Choose your plan",
                      style: TextStyle(
                        fontFamily: Fonts.semiBold,
                        fontSize: 16.sp,
                        color: Colours.white,
                      ),
                    ),
                    verticalSpace(14),
                    _buildPlanCard(
                      title: "Monthly",
                      price: "Rs 299",
                      period: "/month",
                      amount: 299,
                      description:
                          "Flexible billing with full verified benefits.",
                      isRecommended: false,
                    ),
                    verticalSpace(14),
                    _buildPlanCard(
                      title: "Annual",
                      price: "Rs 2,999",
                      period: "/year",
                      amount: 2999,
                      description:
                          "Best value for creators who want year-round verification.",
                      isRecommended: true,
                    ),
                    verticalSpace(24),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(16.w),
                      decoration: BoxDecoration(
                        color: Colours.divider,
                        borderRadius: BorderRadius.circular(18.r),
                        border: Border.all(
                          color: Colours.white.withValues(alpha: 0.08),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Before you subscribe",
                            style: TextStyle(
                              fontFamily: Fonts.semiBold,
                              fontSize: 14.sp,
                              color: Colours.white,
                            ),
                          ),
                          verticalSpace(10),
                          Text(
                            "Your profile name, username, photo, and activity must follow community rules. Billing and verification approval logic can be connected here later.",
                            style: TextStyle(
                              fontFamily: Fonts.light,
                              fontSize: 12.sp,
                              height: 1.6,
                              color: Colours.white.withValues(alpha: 0.72),
                            ),
                          ),
                        ],
                      ),
                    ),
                    verticalSpace(18),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(14.w),
                      decoration: BoxDecoration(
                        color: const Color(0xFF101D36),
                        borderRadius: BorderRadius.circular(16.r),
                        border: Border.all(
                          color: Colours.white.withValues(alpha: 0.08),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.account_balance_wallet_outlined,
                            color: const Color(0xFF8AC4FF),
                            size: 20.sp,
                          ),
                          SizedBox(width: 10.w),
                          Expanded(
                            child: Text(
                              "External wallets like Paytm and PhonePe are supported and handled through Razorpay callbacks.",
                              style: TextStyle(
                                fontFamily: Fonts.light,
                                fontSize: 12.sp,
                                height: 1.5,
                                color: Colours.white.withValues(alpha: 0.74),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    verticalSpace(28),
                    SizedBox(
                      width: double.infinity,
                      height: 52.h,
                      child: ElevatedButton(
                        onPressed:
                            _isProcessingPayment
                                ? null
                                : () => createPayment(_selectedAmount),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colours.white,
                          foregroundColor: Colours.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14.r),
                          ),
                        ),
                        child:
                            _isProcessingPayment
                                ? SizedBox(
                                  height: 20.h,
                                  width: 20.h,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colours.primary,
                                    ),
                                  ),
                                )
                                : Text(
                                  "Continue To Payment",
                                  style: TextStyle(
                                    fontFamily: Fonts.semiBold,
                                    fontSize: 14.sp,
                                    letterSpacing: 1.2,
                                  ),
                                ),
                      ),
                    ),
                    verticalSpace(12),
                    Center(
                      child: Text(
                        "Selected plan: $_selectedPlanTitle",
                        style: TextStyle(
                          fontFamily: Fonts.light,
                          fontSize: 11.sp,
                          color: Colours.white.withValues(alpha: 0.5),
                        ),
                      ),
                    ),
                    verticalSpace(24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(22.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24.r),
        gradient: const LinearGradient(
          colors: [Color(0xFF0F172A), Color(0xFF123C8C), Color(0xFF1E88E5)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 46.h,
            width: 46.h,
            decoration: BoxDecoration(
              color: Colours.white.withValues(alpha: 0.14),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.verified_rounded,
              color: Colours.white,
              size: 24.sp,
            ),
          ),
          SizedBox(height: 18.h),
          Text(
            "Get the verified tick",
            style: TextStyle(
              fontFamily: Fonts.bold,
              fontSize: 22.sp,
              color: Colours.white,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            "Build trust, protect your identity, and unlock a premium profile presence inspired by top creator platforms.",
            style: TextStyle(
              fontFamily: Fonts.light,
              fontSize: 13.sp,
              height: 1.6,
              color: Colours.white.withValues(alpha: 0.88),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureTile({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colours.divider,
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(color: Colours.white.withValues(alpha: 0.06)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 40.h,
            width: 40.h,
            decoration: BoxDecoration(
              color: Colours.white.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(icon, color: Colours.white, size: 20.sp),
          ),
          SizedBox(width: 14.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontFamily: Fonts.medium,
                    fontSize: 14.sp,
                    color: Colours.white,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontFamily: Fonts.light,
                    fontSize: 12.sp,
                    height: 1.5,
                    color: Colours.white.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlanCard({
    required String title,
    required String price,
    required String period,
    required String description,
    required bool isRecommended,
    required int amount,
  }) {
    final isSelected = _selectedAmount == amount;

    return InkWell(
      onTap: () {
        setState(() {
          _selectedAmount = amount;
          _selectedPlanTitle = title;
        });
      },
      borderRadius: BorderRadius.circular(20.r),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(18.w),
        decoration: BoxDecoration(
          color:
              isSelected
                  ? const Color(0xFF101D36)
                  : isRecommended
                  ? const Color(0xFF101D36)
                  : Colours.divider,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color:
                isSelected
                    ? const Color(0xFF8AC4FF)
                    : isRecommended
                    ? const Color(0xFF4DA3FF)
                    : Colours.white.withValues(alpha: 0.12),
            width: isSelected || isRecommended ? 1.1 : 0.8,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                if (isRecommended)
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.w,
                      vertical: 6.h,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF4DA3FF),
                      borderRadius: BorderRadius.circular(30.r),
                    ),
                    child: Text(
                      "Best Value",
                      style: TextStyle(
                        fontFamily: Fonts.semiBold,
                        fontSize: 11.sp,
                        color: Colours.primary,
                      ),
                    ),
                  ),
                if (isRecommended && isSelected) SizedBox(width: 10.w),
                if (isSelected)
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.w,
                      vertical: 6.h,
                    ),
                    decoration: BoxDecoration(
                      color: Colours.white.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(30.r),
                    ),
                    child: Text(
                      "Selected",
                      style: TextStyle(
                        fontFamily: Fonts.semiBold,
                        fontSize: 11.sp,
                        color: Colours.white,
                      ),
                    ),
                  ),
              ],
            ),
            if (isRecommended || isSelected) SizedBox(height: 14.h),
            Text(
              title,
              style: TextStyle(
                fontFamily: Fonts.semiBold,
                fontSize: 16.sp,
                color: Colours.white,
              ),
            ),
            SizedBox(height: 8.h),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: price,
                    style: TextStyle(
                      fontFamily: Fonts.bold,
                      fontSize: 26.sp,
                      color: Colours.white,
                    ),
                  ),
                  TextSpan(
                    text: period,
                    style: TextStyle(
                      fontFamily: Fonts.light,
                      fontSize: 13.sp,
                      color: Colours.white.withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10.h),
            Text(
              description,
              style: TextStyle(
                fontFamily: Fonts.light,
                fontSize: 12.sp,
                height: 1.5,
                color: Colours.white.withValues(alpha: 0.72),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showPaymentFailedDialog(PaymentFailureResponse response) async {
    await showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder:
          (dialogContext) => AlertDialog(
            backgroundColor: const Color(0xFF151515),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(22.r),
            ),
            title: Row(
              children: [
                Container(
                  height: 38.h,
                  width: 38.h,
                  decoration: const BoxDecoration(
                    color: Color(0xFF3B1212),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.close_rounded,
                    color: const Color(0xFFFF7D7D),
                    size: 22.sp,
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Text(
                    "Payment Failed",
                    style: TextStyle(
                      fontFamily: Fonts.bold,
                      fontSize: 18.sp,
                      color: Colours.white,
                    ),
                  ),
                ),
              ],
            ),
            content: Text(
              response.message?.isNotEmpty == true
                  ? response.message!
                  : "We could not complete your $_selectedPlanTitle plan purchase. You can retry the payment or choose another method.",
              style: TextStyle(
                fontFamily: Fonts.light,
                fontSize: 13.sp,
                height: 1.6,
                color: Colours.white.withValues(alpha: 0.75),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext),
                child: Text(
                  "Cancel",
                  style: TextStyle(
                    fontFamily: Fonts.medium,
                    color: Colours.white.withValues(alpha: 0.7),
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(dialogContext);
                  createPayment(_selectedAmount);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colours.white,
                  foregroundColor: Colours.primary,
                ),
                child: Text(
                  "Retry",
                  style: TextStyle(fontFamily: Fonts.semiBold),
                ),
              ),
            ],
          ),
    );
  }

  Future<void> _showGenericFailureDialog() async {
    await showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder:
          (dialogContext) => AlertDialog(
            backgroundColor: const Color(0xFF151515),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(22.r),
            ),
            title: Text(
              "Unable To Start Payment",
              style: TextStyle(
                fontFamily: Fonts.bold,
                fontSize: 18.sp,
                color: Colours.white,
              ),
            ),
            content: Text(
              "Something went wrong while opening the payment sheet. Please try again.",
              style: TextStyle(
                fontFamily: Fonts.light,
                fontSize: 13.sp,
                height: 1.6,
                color: Colours.white.withValues(alpha: 0.75),
              ),
            ),
            actions: [
              ElevatedButton(
                onPressed: () => Navigator.pop(dialogContext),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colours.white,
                  foregroundColor: Colours.primary,
                ),
                child: Text(
                  "Okay",
                  style: TextStyle(fontFamily: Fonts.semiBold),
                ),
              ),
            ],
          ),
    );
  }

  Future<void> _showSuccessDialog(String? paymentId) async {
    _successAnimationController
      ..reset()
      ..forward();

    showGeneralDialog<void>(
      context: context,
      barrierDismissible: false,
      barrierLabel: "payment_success",
      barrierColor: Colors.black.withValues(alpha: 0.72),
      transitionDuration: const Duration(milliseconds: 250),
      pageBuilder: (_, __, ___) {
        return Center(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 28.w),
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 28.h),
            decoration: BoxDecoration(
              color: const Color(0xFF101717),
              borderRadius: BorderRadius.circular(28.r),
              border: Border.all(
                color: const Color(0xFF39D98A).withValues(alpha: 0.35),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ScaleTransition(
                  scale: _successScaleAnimation,
                  child: Container(
                    height: 84.h,
                    width: 84.h,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFF39D98A).withValues(alpha: 0.18),
                      border: Border.all(
                        color: const Color(0xFF39D98A).withValues(alpha: 0.45),
                      ),
                    ),
                    child: Icon(
                      Icons.check_rounded,
                      size: 46.sp,
                      color: const Color(0xFF8EF0BC),
                    ),
                  ),
                ),
                SizedBox(height: 20.h),
                Text(
                  "Verification Activated",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: Fonts.bold,
                    fontSize: 20.sp,
                    color: Colours.white,
                  ),
                ),
                SizedBox(height: 10.h),
                Text(
                  paymentId == null || paymentId.isEmpty
                      ? "Your $_selectedPlanTitle plan payment was successful."
                      : "Payment successful.\nReference: $paymentId",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: Fonts.light,
                    fontSize: 13.sp,
                    height: 1.6,
                    color: Colours.white.withValues(alpha: 0.75),
                  ),
                ),
              ],
            ),
          ),
        );
      },
      transitionBuilder: (_, animation, __, child) {
        return FadeTransition(opacity: animation, child: child);
      },
    );

    await Future.delayed(const Duration(milliseconds: 1800));
    if (!mounted) return;

    Navigator.of(context, rootNavigator: true).pop();
    Navigator.pop(context, true);
  }

  Future<void> _showExternalWalletSheet(String? walletName) async {
    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: const Color(0xFF121212),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
      ),
      builder:
          (sheetContext) => Padding(
            padding: EdgeInsets.fromLTRB(22.w, 16.h, 22.w, 28.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    height: 4.h,
                    width: 46.w,
                    decoration: BoxDecoration(
                      color: Colours.white.withValues(alpha: 0.18),
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                  ),
                ),
                SizedBox(height: 22.h),
                Row(
                  children: [
                    Container(
                      height: 44.h,
                      width: 44.h,
                      decoration: BoxDecoration(
                        color: const Color(0xFF17304F),
                        borderRadius: BorderRadius.circular(14.r),
                      ),
                      child: Icon(
                        Icons.account_balance_wallet_outlined,
                        color: const Color(0xFF8AC4FF),
                        size: 22.sp,
                      ),
                    ),
                    SizedBox(width: 14.w),
                    Expanded(
                      child: Text(
                        "Complete payment in ${walletName ?? 'your wallet'}",
                        style: TextStyle(
                          fontFamily: Fonts.bold,
                          fontSize: 17.sp,
                          color: Colours.white,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 14.h),
                Text(
                  "An external wallet was selected. Finish the payment there, then return to ProSnap. Razorpay will trigger success or failure automatically when the flow completes.",
                  style: TextStyle(
                    fontFamily: Fonts.light,
                    fontSize: 13.sp,
                    height: 1.6,
                    color: Colours.white.withValues(alpha: 0.75),
                  ),
                ),
                SizedBox(height: 18.h),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(14.w),
                  decoration: BoxDecoration(
                    color: Colours.divider,
                    borderRadius: BorderRadius.circular(16.r),
                    border: Border.all(
                      color: Colours.white.withValues(alpha: 0.08),
                    ),
                  ),
                  child: Text(
                    "If the wallet app was closed or payment was not completed, you can come back here and retry safely.",
                    style: TextStyle(
                      fontFamily: Fonts.light,
                      fontSize: 12.sp,
                      height: 1.6,
                      color: Colours.white.withValues(alpha: 0.7),
                    ),
                  ),
                ),
                SizedBox(height: 18.h),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(sheetContext),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(
                            color: Colours.white.withValues(alpha: 0.16),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14.r),
                          ),
                        ),
                        child: Text(
                          "Close",
                          style: TextStyle(
                            fontFamily: Fonts.medium,
                            color: Colours.white,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(sheetContext);
                          createPayment(_selectedAmount);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colours.white,
                          foregroundColor: Colours.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14.r),
                          ),
                        ),
                        child: Text(
                          "Retry",
                          style: TextStyle(fontFamily: Fonts.semiBold),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
    );
  }
}
