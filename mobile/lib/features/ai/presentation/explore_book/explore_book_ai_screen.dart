import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import 'ai_result_model.dart';
import 'ai_input_bar.dart';
import 'ai_idle_state.dart';
import 'ai_results_state.dart';

class ExploreBookAiScreen extends StatefulWidget {
  final String? initialQuery;
  const ExploreBookAiScreen({super.key, this.initialQuery});

  @override
  State<ExploreBookAiScreen> createState() => _ExploreBookAiScreenState();
}

class _ExploreBookAiScreenState extends State<ExploreBookAiScreen> {
  final _inputCtrl = TextEditingController();

  _ScreenState _state = _ScreenState.idle;
  String _summary = '';
  List<AiResult> _destinations = [];
  String _currentQuery = '';

  @override
  void initState() {
    super.initState();
    if (widget.initialQuery?.isNotEmpty == true) {
      _inputCtrl.text = widget.initialQuery!;
      WidgetsBinding.instance
          .addPostFrameCallback((_) => _search(widget.initialQuery!));
    }
  }

  @override
  void dispose() {
    _inputCtrl.dispose();
    super.dispose();
  }

  void _search(String query) {
    final q = query.trim();
    if (q.isEmpty) return;
    FocusScope.of(context).unfocus();
    setState(() {
      _state = _ScreenState.loading;
      _currentQuery = q;
    });

    Future.delayed(const Duration(milliseconds: 1600), () {
      if (!mounted) return;
      final result = simulateSearch(q);
      setState(() {
        _state = _ScreenState.results;
        _summary = result.summary;
        _destinations = result.destinations;
      });
      _inputCtrl.clear();
    });
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
              // ── App bar ──
              _AppBar(query: _currentQuery, state: _state),

              // ── Body ──
              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: switch (_state) {
                    _ScreenState.idle => AiIdleState(
                        key: const ValueKey('idle'),
                        onChipTap: (q) {
                          _inputCtrl.text = q;
                          _search(q);
                        },
                      ),
                    _ScreenState.loading => _LoadingState(
                        key: const ValueKey('loading'),
                        query: _currentQuery,
                      ),
                    _ScreenState.results => AiResultsState(
                        key: ValueKey(_currentQuery),
                        summary: _summary,
                        destinations: _destinations,
                      ),
                  },
                ),
              ),

              // ── Input bar (always at bottom) ──
              AiInputBar(
                controller: _inputCtrl,
                isLoading: _state == _ScreenState.loading,
                onSend: _search,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

enum _ScreenState { idle, loading, results }

// ── App bar ───────────────────────────────────────────────────────────────────
class _AppBar extends StatelessWidget {
  final String query;
  final _ScreenState state;
  const _AppBar({required this.query, required this.state});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.background,
      padding: EdgeInsets.fromLTRB(8.w, 8.h, 20.w, 8.h),
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
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Explore & Book with AI',
                    style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textHeading)),
                if (state == _ScreenState.results && query.isNotEmpty)
                  Text('"$query"',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: 11.sp, color: AppColors.textSecondary)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Loading state ─────────────────────────────────────────────────────────────
class _LoadingState extends StatelessWidget {
  final String query;
  const _LoadingState({super.key, required this.query});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 48.w,
            height: 48.w,
            child: CircularProgressIndicator(
                strokeWidth: 3, color: AppColors.primary),
          ),
          SizedBox(height: 20.h),
          Text('Searching for "$query"',
              style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textHeading)),
          SizedBox(height: 6.h),
          Text('Keza AI is finding the best options...',
              style:
                  TextStyle(fontSize: 13.sp, color: AppColors.textSecondary)),
        ],
      ),
    );
  }
}
