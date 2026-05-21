import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../core/theme/app_colors.dart';
import 'explore_book/explore_book_ai_screen.dart';
import 'trip_builder/ai_trip_builder_screen.dart';

// ── Models ────────────────────────────────────────────────────────────────────
enum _Sender { user, ai }
enum _CtaType { exploreBook, tripBuilder }

class _Msg {
  final _Sender sender;
  final String text;
  final _CtaType? cta;
  _Msg({required this.sender, required this.text, this.cta});
}

// ── Simulated replies ─────────────────────────────────────────────────────────
_Msg _reply(String q) {
  final l = q.toLowerCase();
  if (l.contains('visa')) {
    return _Msg(
      sender: _Sender.ai,
      text: 'Rwanda offers visa-on-arrival for most nationalities at Kigali International Airport — cost is \$50 USD. '
          'East African citizens enter free. You can also apply online via the Rwanda e-Visa portal before travel. '
          'Required documents: valid passport (6+ months), return ticket, proof of accommodation, and yellow fever certificate.',
    );
  }
  if (l.contains('safe') || l.contains('security')) {
    return _Msg(
      sender: _Sender.ai,
      text: 'Rwanda is consistently ranked one of the safest countries in Africa. '
          'Kigali has very low crime rates. The country has a strong police presence and is well-governed. '
          'Standard travel precautions apply — keep valuables secure, avoid walking alone late at night in unfamiliar areas. '
          'Emergency number: 112.',
    );
  }
  if (l.contains('season') || l.contains('weather') || l.contains('best time')) {
    return _Msg(
      sender: _Sender.ai,
      text: 'Rwanda has two dry seasons — June to September (long dry) and December to February (short dry). '
          'The best time to visit is June–September: ideal for gorilla trekking, wildlife safaris, and hiking. '
          'Avoid April–May (heavy rains). The country is green year-round due to its equatorial climate.',
    );
  }
  if (l.contains('currency') || l.contains('money') || l.contains('pay')) {
    return _Msg(
      sender: _Sender.ai,
      text: 'The currency is the Rwandan Franc (RWF). USD is widely accepted in hotels and tourist areas. '
          'ATMs are available in Kigali and major towns. Credit cards work in most hotels and restaurants. '
          'Mobile money (MTN MoMo) is widely used for local payments.',
    );
  }
  if (l.contains('gorilla') || l.contains('trek') || l.contains('volcanoes')) {
    return _Msg(
      sender: _Sender.ai,
      text: 'Gorilla trekking in Volcanoes National Park is Rwanda\'s most iconic experience. '
          'Permits cost \$1,500 per person and must be booked in advance through Rwanda Development Board. '
          'Best season: June–September. Most visitors stay in Musanze or Kinigi. Want me to find accommodation?',
      cta: _CtaType.exploreBook,
    );
  }
  if (l.contains('itinerary') || l.contains('plan') || l.contains('trip')) {
    return _Msg(
      sender: _Sender.ai,
      text: 'I can build a full personalised itinerary based on your interests, budget, and travel style. '
          'The AI Trip Builder will create a day-by-day plan with accommodation at every stop.',
      cta: _CtaType.tripBuilder,
    );
  }
  if (l.contains('kigali')) {
    return _Msg(
      sender: _Sender.ai,
      text: 'Kigali is one of Africa\'s cleanest and most vibrant capitals. Top things to do: '
          'Kigali Genocide Memorial, Kimironko Market, Inema Arts Center, and Nyamirambo for local food. '
          'Want me to find accommodation in Kigali?',
      cta: _CtaType.exploreBook,
    );
  }
  if (l.contains('food') || l.contains('eat') || l.contains('restaurant')) {
    return _Msg(
      sender: _Sender.ai,
      text: 'Rwandan cuisine features dishes like Isombe (cassava leaves), Ugali (maize porridge), '
          'Brochettes (grilled meat skewers), and Akabanga (chilli oil). '
          'Kigali has a growing restaurant scene with everything from local to international cuisine. '
          'Nyamirambo neighbourhood is the best spot for authentic local food.',
    );
  }
  return _Msg(
    sender: _Sender.ai,
    text: 'Great question! Rwanda has so much to offer — wildlife, culture, history, and stunning landscapes. '
        'Could you tell me more about what you\'re looking for? I can help with visa info, safety, best seasons, '
        'accommodation, or building a full trip plan.',
  );
}

// ── Screen ────────────────────────────────────────────────────────────────────
class GeneralChatScreen extends StatefulWidget {
  final String? initialPrompt;
  const GeneralChatScreen({super.key, this.initialPrompt});

  @override
  State<GeneralChatScreen> createState() => _GeneralChatScreenState();
}

class _GeneralChatScreenState extends State<GeneralChatScreen>
    with TickerProviderStateMixin {
  final _inputCtrl = TextEditingController();
  final _focusNode = FocusNode();
  final _scrollCtrl = ScrollController();
  final List<_Msg> _messages = [];
  bool _isTyping = false;
  bool _hasText = false;
  late final AnimationController _typingCtrl;

  @override
  void initState() {
    super.initState();
    _typingCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 900))
      ..repeat();
    _inputCtrl.addListener(() {
      final has = _inputCtrl.text.trim().isNotEmpty;
      if (has != _hasText) setState(() => _hasText = has);
    });
    if (widget.initialPrompt?.isNotEmpty == true) {
      WidgetsBinding.instance
          .addPostFrameCallback((_) => _send(widget.initialPrompt!));
    }
  }

  @override
  void dispose() {
    _inputCtrl.dispose();
    _focusNode.dispose();
    _scrollCtrl.dispose();
    _typingCtrl.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollCtrl.hasClients) {
        _scrollCtrl.animateTo(_scrollCtrl.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
      }
    });
  }

  void _send(String text) {
    final t = text.trim();
    if (t.isEmpty || _isTyping) return;
    FocusScope.of(context).unfocus();
    setState(() {
      _messages.add(_Msg(sender: _Sender.user, text: t));
      _isTyping = true;
      _inputCtrl.clear();
    });
    _scrollToBottom();
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (!mounted) return;
      setState(() {
        _isTyping = false;
        _messages.add(_reply(t));
      });
      _scrollToBottom();
    });
  }

  void _handleCta(_CtaType type) {
    final lastUserMsg = _messages
        .lastWhere((m) => m.sender == _Sender.user,
            orElse: () => _Msg(sender: _Sender.user, text: ''))
        .text;
    if (type == _CtaType.exploreBook) {
      Navigator.push(context, MaterialPageRoute(
          builder: (_) => ExploreBookAiScreen(initialQuery: lastUserMsg)));
    } else {
      Navigator.push(context, MaterialPageRoute(
          builder: (_) => const AiTripBuilderScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: Column(
            children: [
              _ChatAppBar(),
              Expanded(
                child: _messages.isEmpty && !_isTyping
                    ? _EmptyState(onChipTap: _send)
                    : ListView.builder(
                        controller: _scrollCtrl,
                        padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 16.h),
                        itemCount: _messages.length + (_isTyping ? 1 : 0),
                        itemBuilder: (_, i) {
                          if (_isTyping && i == _messages.length) {
                            return _TypingBubble(ctrl: _typingCtrl);
                          }
                          final msg = _messages[i];
                          return msg.sender == _Sender.user
                              ? _UserBubble(msg: msg)
                              : _AiBubble(
                                  msg: msg,
                                  onCtaTap: _handleCta,
                                );
                        },
                      ),
              ),
              _InputBar(
                controller: _inputCtrl,
                focusNode: _focusNode,
                hasText: _hasText,
                isLoading: _isTyping,
                onSend: () => _send(_inputCtrl.text),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── App bar ───────────────────────────────────────────────────────────────────
class _ChatAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.background,
      padding: EdgeInsets.fromLTRB(8.w, 8.h, 16.w, 8.h),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.maybePop(context),
            child: Container(
              width: 40.w,
              height: 40.w,
              margin: EdgeInsets.only(left: 8.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.r),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.06),
                      blurRadius: 8,
                      offset: const Offset(0, 2)),
                ],
              ),
              child: Icon(Icons.arrow_back_ios_new_rounded,
                  size: 16.w, color: AppColors.textHeading),
            ),
          ),
          SizedBox(width: 12.w),
          Container(
            width: 36.w,
            height: 36.w,
            decoration: const BoxDecoration(
                gradient: AppColors.aiGradient, shape: BoxShape.circle),
            child: Center(
              child: SvgPicture.asset('assets/general/main-logo.svg',
                  width: 18.w,
                  colorFilter:
                      const ColorFilter.mode(Colors.white, BlendMode.srcIn)),
            ),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Keza AI',
                    style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textHeading)),
                Row(
                  children: [
                    Container(
                        width: 6.w,
                        height: 6.w,
                        decoration: const BoxDecoration(
                            color: AppColors.primary, shape: BoxShape.circle)),
                    SizedBox(width: 4.w),
                    Text('Online',
                        style: TextStyle(
                            fontSize: 11.sp,
                            color: AppColors.primary,
                            fontWeight: FontWeight.w500)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Empty state with topic chips ──────────────────────────────────────────────
class _EmptyState extends StatelessWidget {
  final ValueChanged<String> onChipTap;
  const _EmptyState({required this.onChipTap});

  static const _topics = [
    ('🛂', 'Visa requirements'),
    ('🛡️', 'Is Rwanda safe?'),
    ('🌤️', 'Best time to visit'),
    ('💵', 'Currency & payments'),
    ('🦍', 'Gorilla trekking info'),
    ('🍽️', 'Local food & restaurants'),
    ('🏥', 'Health & vaccinations'),
    ('📱', 'SIM card & internet'),
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(20.w, 24.h, 20.w, 24.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Column(
              children: [
                Opacity(
                  opacity: 0.08,
                  child: SvgPicture.asset('assets/general/main-logo.svg',
                      width: 80.w,
                      colorFilter: const ColorFilter.mode(
                          AppColors.primaryDarker, BlendMode.srcIn)),
                ),
                SizedBox(height: 12.h),
                Text('Ask me anything about Rwanda',
                    style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textHeading)),
                SizedBox(height: 4.h),
                Text('Visa, safety, weather, culture and more',
                    style: TextStyle(
                        fontSize: 12.sp, color: AppColors.textSecondary)),
              ],
            ),
          ),
          SizedBox(height: 28.h),
          Text('Popular topics',
              style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textHeading)),
          SizedBox(height: 12.h),
          Wrap(
            spacing: 8.w,
            runSpacing: 8.h,
            children: _topics.map((t) {
              return GestureDetector(
                onTap: () => onChipTap(t.$2),
                child: Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 12.w, vertical: 9.h),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20.r),
                    border: Border.all(color: AppColors.surfaceBorder),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withOpacity(0.03),
                          blurRadius: 6,
                          offset: const Offset(0, 2)),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(t.$1, style: TextStyle(fontSize: 13.sp)),
                      SizedBox(width: 6.w),
                      Text(t.$2,
                          style: TextStyle(
                              fontSize: 12.sp,
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.w500)),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

// ── User bubble ───────────────────────────────────────────────────────────────
class _UserBubble extends StatelessWidget {
  final _Msg msg;
  const _UserBubble({required this.msg});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h, left: 48.w),
      child: Align(
        alignment: Alignment.centerRight,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          decoration: BoxDecoration(
            gradient: AppColors.aiGradient,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(18.r),
              topRight: Radius.circular(18.r),
              bottomLeft: Radius.circular(18.r),
              bottomRight: Radius.circular(4.r),
            ),
          ),
          child: Text(msg.text,
              style: TextStyle(
                  fontSize: 14.sp, color: Colors.white, height: 1.5)),
        ),
      ),
    );
  }
}

// ── AI bubble ─────────────────────────────────────────────────────────────────
class _AiBubble extends StatelessWidget {
  final _Msg msg;
  final ValueChanged<_CtaType> onCtaTap;
  const _AiBubble({required this.msg, required this.onCtaTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h, right: 48.w),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            width: 28.w,
            height: 28.w,
            margin: EdgeInsets.only(right: 8.w),
            decoration: const BoxDecoration(
                gradient: AppColors.aiGradient, shape: BoxShape.circle),
            child: Center(
              child: SvgPicture.asset('assets/general/main-logo.svg',
                  width: 14.w,
                  colorFilter: const ColorFilter.mode(
                      Colors.white, BlendMode.srcIn)),
            ),
          ),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(4.r),
                      topRight: Radius.circular(18.r),
                      bottomLeft: Radius.circular(18.r),
                      bottomRight: Radius.circular(18.r),
                    ),
                    border: Border.all(color: AppColors.surfaceBorder),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 8,
                          offset: const Offset(0, 2)),
                    ],
                  ),
                  child: Text(msg.text,
                      style: TextStyle(
                          fontSize: 14.sp,
                          color: AppColors.textPrimary,
                          height: 1.55)),
                ),
                if (msg.cta != null) ...[
                  SizedBox(height: 8.h),
                  _CtaChip(type: msg.cta!, onTap: () => onCtaTap(msg.cta!)),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Inline CTA chip ───────────────────────────────────────────────────────────
class _CtaChip extends StatelessWidget {
  final _CtaType type;
  final VoidCallback onTap;
  const _CtaChip({required this.type, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isExplore = type == _CtaType.exploreBook;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: isExplore ? AppColors.primarySoft : AppColors.infoSoft,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: isExplore
                ? AppColors.primary.withOpacity(0.3)
                : AppColors.info.withOpacity(0.3),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isExplore ? Icons.auto_awesome_rounded : Icons.route_rounded,
              size: 15.w,
              color: isExplore ? AppColors.primary : AppColors.info,
            ),
            SizedBox(width: 8.w),
            Text(
              isExplore ? 'Find & Book with AI' : 'Build Full Itinerary',
              style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                  color: isExplore ? AppColors.primaryDark : AppColors.info),
            ),
            SizedBox(width: 6.w),
            Icon(Icons.arrow_forward_rounded,
                size: 13.w,
                color: isExplore ? AppColors.primary : AppColors.info),
          ],
        ),
      ),
    );
  }
}

// ── Typing indicator ──────────────────────────────────────────────────────────
class _TypingBubble extends StatelessWidget {
  final AnimationController ctrl;
  const _TypingBubble({required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h, right: 48.w),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            width: 28.w,
            height: 28.w,
            margin: EdgeInsets.only(right: 8.w),
            decoration: const BoxDecoration(
                gradient: AppColors.aiGradient, shape: BoxShape.circle),
            child: Center(
              child: SvgPicture.asset('assets/general/main-logo.svg',
                  width: 14.w,
                  colorFilter: const ColorFilter.mode(
                      Colors.white, BlendMode.srcIn)),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(4.r),
                topRight: Radius.circular(18.r),
                bottomLeft: Radius.circular(18.r),
                bottomRight: Radius.circular(18.r),
              ),
              border: Border.all(color: AppColors.surfaceBorder),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(
                  3, (i) => _Dot(ctrl: ctrl, index: i)),
            ),
          ),
        ],
      ),
    );
  }
}

class _Dot extends StatelessWidget {
  final AnimationController ctrl;
  final int index;
  const _Dot({required this.ctrl, required this.index});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: ctrl,
      builder: (_, __) {
        final v = (ctrl.value - index * 0.15).clamp(0.0, 1.0);
        final b = (v < 0.5 ? v : 1.0 - v) * 2;
        return Container(
          width: 7.w,
          height: 7.w,
          margin: EdgeInsets.only(right: index < 2 ? 4.w : 0),
          transform: Matrix4.translationValues(0, -4 * b, 0),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.5 + b * 0.5),
            shape: BoxShape.circle,
          ),
        );
      },
    );
  }
}

// ── Input bar (pill style matching CustomSearchBar) ───────────────────────────
class _InputBar extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final bool hasText;
  final bool isLoading;
  final VoidCallback onSend;

  const _InputBar({
    required this.controller,
    required this.focusNode,
    required this.hasText,
    required this.isLoading,
    required this.onSend,
  });

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).padding.bottom;
    return Container(
      padding: EdgeInsets.fromLTRB(
          16.w, 10.h, 16.w, bottom > 0 ? bottom + 6.h : 14.h),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: AppColors.surfaceBorder)),
      ),
      child: Container(
        padding: EdgeInsets.only(left: 14.w, right: 6.w, top: 6.h, bottom: 6.h),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(50.r),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 8,
                offset: const Offset(0, 2)),
          ],
        ),
        child: Row(
          children: [
            Icon(Icons.chat_bubble_outline_rounded,
                color: AppColors.primary, size: 20.w),
            SizedBox(width: 8.w),
            Expanded(
              child: TextField(
                controller: controller,
                focusNode: focusNode,
                maxLines: 1,
                style:
                    TextStyle(fontSize: 13.sp, color: AppColors.textPrimary),
                textInputAction: TextInputAction.send,
                onSubmitted: (_) => onSend(),
                decoration: InputDecoration(
                  hintText: 'Ask anything about Rwanda...',
                  hintStyle: TextStyle(
                      fontSize: 13.sp, color: AppColors.textSecondary),
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ),
            SizedBox(width: 4.w),
            GestureDetector(
              onTap: onSend,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: hasText && !isLoading
                      ? AppColors.primary
                      : AppColors.surfaceBorder,
                  shape: BoxShape.circle,
                ),
                child: isLoading
                    ? SizedBox(
                        width: 16.w,
                        height: 16.w,
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: Colors.white),
                      )
                    : Icon(Icons.arrow_upward_rounded,
                        color:
                            hasText ? Colors.white : AppColors.textDisabled,
                        size: 16.w),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Reusable app bar icon button (exported for other screens) ─────────────────
class AppBarIconBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const AppBarIconBtn({super.key, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 38.w,
        height: 38.w,
        decoration: BoxDecoration(
          color: AppColors.surfaceBorder.withOpacity(0.5),
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Icon(icon, size: 20.w, color: AppColors.textHeading),
      ),
    );
  }
}
