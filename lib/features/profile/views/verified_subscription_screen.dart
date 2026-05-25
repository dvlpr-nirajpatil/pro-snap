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
  static const _razorpayKey = 'rzp_test_RJLx4xAV8HGFCq';

  late final Razorpay _razorpay;
  late final AnimationController _successController;
  late final Animation<double> _successScale;

  int _selectedPlanIndex = 1;
  bool _isProcessingPayment = false;

  _VerifiedPlan get _selectedPlan => _plans[_selectedPlanIndex];

  static const List<_VerifiedFeature> _features = [
    _VerifiedFeature(
      icon: Icons.verified_rounded,
      title: "Verified badge",
      subtitle: "Stand out with a blue check beside your name across the app.",
    ),
    _VerifiedFeature(
      icon: Icons.support_agent_rounded,
      title: "Priority support",
      subtitle:
          "Get faster account help when you need profile or safety support.",
    ),
    _VerifiedFeature(
      icon: Icons.visibility_outlined,
      title: "Stronger trust signals",
      subtitle:
          "Show your audience that your account is confirmed and authentic.",
    ),
  ];

  static const List<_VerifiedPlan> _plans = [
    _VerifiedPlan(
      title: "Monthly",
      price: "Rs 299",
      period: "/month",
      amount: 299,
      description: "Flexible billing with full verified benefits.",
    ),
    _VerifiedPlan(
      title: "Annual",
      price: "Rs 2,999",
      period: "/year",
      amount: 2999,
      description: "Best value for creators who want year-round verification.",
      isRecommended: true,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _successController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _successScale = CurvedAnimation(
      parent: _successController,
      curve: Curves.elasticOut,
    );

    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose() {
    _razorpay.clear();
    _successController.dispose();
    super.dispose();
  }

  void _selectPlan(int index) {
    if (_isProcessingPayment || _selectedPlanIndex == index) return;
    setState(() => _selectedPlanIndex = index);
  }

  void _startPayment() {
    if (_isProcessingPayment) return;

    setState(() => _isProcessingPayment = true);

    final plan = _selectedPlan;
    final options = {
      'key': _razorpayKey,
      'amount': plan.amount * 100,
      'currency': 'INR',
      'name': 'ProSnap Verified',
      'description': '${plan.title} verified subscription',
      'prefill': {'contact': '8888888888', 'email': 'test@razorpay.com'},
      'external': {
        'wallets': ['paytm'],
      },
    };

    try {
      _razorpay.open(options);
    } catch (_) {
      if (!mounted) return;
      setState(() => _isProcessingPayment = false);
      _showGenericFailureDialog();
    }
  }

  Future<void> _handlePaymentSuccess(PaymentSuccessResponse response) async {
    if (!mounted) return;
    setState(() => _isProcessingPayment = false);
    await _showSuccessDialog(response.paymentId);
  }

  Future<void> _handlePaymentError(PaymentFailureResponse response) async {
    if (!mounted) return;
    setState(() => _isProcessingPayment = false);
    await _showPaymentFailedDialog(response);
  }

  Future<void> _handleExternalWallet(ExternalWalletResponse response) async {
    if (!mounted) return;
    setState(() => _isProcessingPayment = false);
    await _showExternalWalletSheet(response.walletName);
  }

  Widget verticalSpace(double height) => SizedBox(height: height.h);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colours.primary,
      body: SafeArea(
        child: Column(
          children: [
            _TopBar(onBack: () => Navigator.pop(context)),
            Divider(color: Colours.divider, thickness: 0.5, height: 1),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(20.w, 24.h, 20.w, 24.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const _HeroCard(),
                    verticalSpace(24),
                    const _SectionTitle("What you get"),
                    verticalSpace(14),
                    for (final feature in _features) ...[
                      _FeatureTile(feature: feature),
                      SizedBox(height: 12.h),
                    ],
                    verticalSpace(14),
                    const _SectionTitle("Choose your plan"),
                    verticalSpace(14),
                    for (int index = 0; index < _plans.length; index++) ...[
                      _PlanCard(
                        plan: _plans[index],
                        isSelected: _selectedPlanIndex == index,
                        isEnabled: !_isProcessingPayment,
                        onTap: () => _selectPlan(index),
                      ),
                      if (index != _plans.length - 1) SizedBox(height: 14.h),
                    ],
                    verticalSpace(24),
                    const _InfoCard(
                      title: "Before you subscribe",
                      body:
                          "Your profile name, username, photo, and activity must follow community rules. Billing and verification approval logic can be connected here later.",
                    ),
                    verticalSpace(14),
                    const _WalletNote(),
                    verticalSpace(28),
                    _PaymentButton(
                      isLoading: _isProcessingPayment,
                      onPressed: _startPayment,
                    ),
                    verticalSpace(12),
                    Center(
                      child: Text(
                        "Selected plan: ${_selectedPlan.title}",
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

  Future<void> _showPaymentFailedDialog(PaymentFailureResponse response) async {
    await showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder:
          (dialogContext) => _PaymentDialog(
            icon: Icons.close_rounded,
            iconBackground: const Color(0xFF3B1212),
            iconColor: const Color(0xFFFF7D7D),
            title: "Payment Failed",
            message:
                response.message?.isNotEmpty == true
                    ? response.message!
                    : "We could not complete your ${_selectedPlan.title} plan purchase. You can retry the payment or choose another method.",
            primaryLabel: "Retry",
            onPrimary: () {
              Navigator.pop(dialogContext);
              _startPayment();
            },
            secondaryLabel: "Cancel",
            onSecondary: () => Navigator.pop(dialogContext),
          ),
    );
  }

  Future<void> _showGenericFailureDialog() async {
    await showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder:
          (dialogContext) => _PaymentDialog(
            icon: Icons.priority_high_rounded,
            iconBackground: Colours.divider,
            iconColor: Colours.white,
            title: "Unable To Start Payment",
            message:
                "Something went wrong while opening the payment sheet. Please try again.",
            primaryLabel: "Okay",
            onPrimary: () => Navigator.pop(dialogContext),
          ),
    );
  }

  Future<void> _showSuccessDialog(String? paymentId) async {
    _successController
      ..reset()
      ..forward();

    showGeneralDialog<void>(
      context: context,
      barrierDismissible: false,
      barrierLabel: "payment_success",
      barrierColor: Colors.black.withValues(alpha: 0.72),
      transitionDuration: const Duration(milliseconds: 250),
      pageBuilder:
          (_, __, ___) => _SuccessDialog(
            scale: _successScale,
            planTitle: _selectedPlan.title,
            paymentId: paymentId,
          ),
      transitionBuilder:
          (_, animation, __, child) =>
              FadeTransition(opacity: animation, child: child),
    );

    await Future.delayed(const Duration(milliseconds: 1800));
    if (!mounted) return;

    final navigator = Navigator.of(context, rootNavigator: true);
    if (navigator.canPop()) {
      navigator.pop();
    }
    if (mounted && Navigator.of(context).canPop()) {
      Navigator.pop(context, true);
    }
  }

  Future<void> _showExternalWalletSheet(String? walletName) async {
    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: const Color(0xFF121212),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
      ),
      builder:
          (sheetContext) => _ExternalWalletSheet(
            walletName: walletName,
            onRetry: () {
              Navigator.pop(sheetContext);
              _startPayment();
            },
          ),
    );
  }
}

class _VerifiedPlan {
  final String title;
  final String price;
  final String period;
  final int amount;
  final String description;
  final bool isRecommended;

  const _VerifiedPlan({
    required this.title,
    required this.price,
    required this.period,
    required this.amount,
    required this.description,
    this.isRecommended = false,
  });
}

class _VerifiedFeature {
  final IconData icon;
  final String title;
  final String subtitle;

  const _VerifiedFeature({
    required this.icon,
    required this.title,
    required this.subtitle,
  });
}

class _TopBar extends StatelessWidget {
  final VoidCallback onBack;

  const _TopBar({required this.onBack});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
      child: Row(
        children: [
          IconButton(
            tooltip: "Back",
            onPressed: onBack,
            icon: Icon(
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
              letterSpacing: 1.2,
              color: Colours.white,
            ),
          ),
          const Spacer(),
          SizedBox(width: 48.w),
        ],
      ),
    );
  }
}

class _HeroCard extends StatelessWidget {
  const _HeroCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(22.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
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
}

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle(this.title);

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        fontFamily: Fonts.semiBold,
        fontSize: 16.sp,
        color: Colours.white,
      ),
    );
  }
}

class _FeatureTile extends StatelessWidget {
  final _VerifiedFeature feature;

  const _FeatureTile({required this.feature});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colours.divider,
        borderRadius: BorderRadius.circular(14.r),
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
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Icon(feature.icon, color: Colours.white, size: 20.sp),
          ),
          SizedBox(width: 14.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  feature.title,
                  style: TextStyle(
                    fontFamily: Fonts.medium,
                    fontSize: 14.sp,
                    color: Colours.white,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  feature.subtitle,
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
}

class _PlanCard extends StatelessWidget {
  final _VerifiedPlan plan;
  final bool isSelected;
  final bool isEnabled;
  final VoidCallback onTap;

  const _PlanCard({
    required this.plan,
    required this.isSelected,
    required this.isEnabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final borderColor =
        isSelected
            ? const Color(0xFF8AC4FF)
            : plan.isRecommended
            ? const Color(0xFF4DA3FF)
            : Colours.white.withValues(alpha: 0.12);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: isEnabled ? onTap : null,
        borderRadius: BorderRadius.circular(16.r),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          width: double.infinity,
          padding: EdgeInsets.all(18.w),
          decoration: BoxDecoration(
            color:
                isSelected || plan.isRecommended
                    ? const Color(0xFF101D36)
                    : Colours.divider,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(
              color: borderColor,
              width: isSelected || plan.isRecommended ? 1.1 : 0.8,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                spacing: 10.w,
                runSpacing: 8.h,
                children: [
                  if (plan.isRecommended)
                    const _PlanBadge(
                      label: "Best Value",
                      background: Color(0xFF4DA3FF),
                      foreground: Colours.primary,
                    ),
                  if (isSelected)
                    _PlanBadge(
                      label: "Selected",
                      background: Colours.white.withValues(alpha: 0.12),
                      foreground: Colours.white,
                    ),
                ],
              ),
              if (plan.isRecommended || isSelected) SizedBox(height: 14.h),
              Text(
                plan.title,
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
                      text: plan.price,
                      style: TextStyle(
                        fontFamily: Fonts.bold,
                        fontSize: 26.sp,
                        color: Colours.white,
                      ),
                    ),
                    TextSpan(
                      text: plan.period,
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
                plan.description,
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
      ),
    );
  }
}

class _PlanBadge extends StatelessWidget {
  final String label;
  final Color background;
  final Color foreground;

  const _PlanBadge({
    required this.label,
    required this.background,
    required this.foreground,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(30.r),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontFamily: Fonts.semiBold,
          fontSize: 11.sp,
          color: foreground,
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final String title;
  final String body;

  const _InfoCard({required this.title, required this.body});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colours.divider,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: Colours.white.withValues(alpha: 0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontFamily: Fonts.semiBold,
              fontSize: 14.sp,
              color: Colours.white,
            ),
          ),
          SizedBox(height: 10.h),
          Text(
            body,
            style: TextStyle(
              fontFamily: Fonts.light,
              fontSize: 12.sp,
              height: 1.6,
              color: Colours.white.withValues(alpha: 0.72),
            ),
          ),
        ],
      ),
    );
  }
}

class _WalletNote extends StatelessWidget {
  const _WalletNote();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: const Color(0xFF101D36),
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: Colours.white.withValues(alpha: 0.08)),
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
              "External wallets like Paytm are supported and handled through Razorpay callbacks.",
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
    );
  }
}

class _PaymentButton extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onPressed;

  const _PaymentButton({required this.isLoading, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52.h,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colours.white,
          foregroundColor: Colours.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
        ),
        child:
            isLoading
                ? SizedBox(
                  height: 20.h,
                  width: 20.h,
                  child: const CircularProgressIndicator(
                    strokeWidth: 2.2,
                    color: Colours.primary,
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
    );
  }
}

class _PaymentDialog extends StatelessWidget {
  final IconData icon;
  final Color iconBackground;
  final Color iconColor;
  final String title;
  final String message;
  final String primaryLabel;
  final VoidCallback onPrimary;
  final String? secondaryLabel;
  final VoidCallback? onSecondary;

  const _PaymentDialog({
    required this.icon,
    required this.iconBackground,
    required this.iconColor,
    required this.title,
    required this.message,
    required this.primaryLabel,
    required this.onPrimary,
    this.secondaryLabel,
    this.onSecondary,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color(0xFF151515),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
      title: Row(
        children: [
          Container(
            height: 38.h,
            width: 38.h,
            decoration: BoxDecoration(
              color: iconBackground,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: 22.sp),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              title,
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
        message,
        style: TextStyle(
          fontFamily: Fonts.light,
          fontSize: 13.sp,
          height: 1.6,
          color: Colours.white.withValues(alpha: 0.75),
        ),
      ),
      actions: [
        if (secondaryLabel != null && onSecondary != null)
          TextButton(
            onPressed: onSecondary,
            child: Text(
              secondaryLabel!,
              style: TextStyle(
                fontFamily: Fonts.medium,
                color: Colours.white.withValues(alpha: 0.7),
              ),
            ),
          ),
        ElevatedButton(
          onPressed: onPrimary,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colours.white,
            foregroundColor: Colours.primary,
          ),
          child: Text(
            primaryLabel,
            style: TextStyle(fontFamily: Fonts.semiBold),
          ),
        ),
      ],
    );
  }
}

class _SuccessDialog extends StatelessWidget {
  final Animation<double> scale;
  final String planTitle;
  final String? paymentId;

  const _SuccessDialog({
    required this.scale,
    required this.planTitle,
    required this.paymentId,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 28.w),
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 28.h),
        decoration: BoxDecoration(
          color: const Color(0xFF101717),
          borderRadius: BorderRadius.circular(24.r),
          border: Border.all(
            color: const Color(0xFF39D98A).withValues(alpha: 0.35),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ScaleTransition(
              scale: scale,
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
              paymentId == null || paymentId!.isEmpty
                  ? "Your $planTitle plan payment was successful."
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
  }
}

class _ExternalWalletSheet extends StatelessWidget {
  final String? walletName;
  final VoidCallback onRetry;

  const _ExternalWalletSheet({required this.walletName, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Padding(
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
                  borderRadius: BorderRadius.circular(12.r),
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
            "Finish the payment there, then return to ProSnap. Razorpay will trigger success or failure automatically when the flow completes.",
            style: TextStyle(
              fontFamily: Fonts.light,
              fontSize: 13.sp,
              height: 1.6,
              color: Colours.white.withValues(alpha: 0.75),
            ),
          ),
          SizedBox(height: 18.h),
          const _InfoCard(
            title: "Safe to retry",
            body:
                "If the wallet app was closed or payment was not completed, you can come back here and retry safely.",
          ),
          SizedBox(height: 18.h),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(
                      color: Colours.white.withValues(alpha: 0.16),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
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
                  onPressed: onRetry,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colours.white,
                    foregroundColor: Colours.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
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
    );
  }
}
