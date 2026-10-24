import 'dart:ui' show ImageFilter;

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show HapticFeedback;
import '../core/colors.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/home_controller.dart';
import 'chat_view.dart';
import 'model_view.dart';
import 'server_view.dart';
import 'settings_view.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  static const _tabs = [
    _NavItem(
        icon: Icons.bubble_chart_outlined,
        activeIcon: Icons.bubble_chart,
        label: 'Chat'),
    _NavItem(
        icon: Icons.arrow_downward_rounded,
        activeIcon: Icons.arrow_downward_rounded,
        label: 'Models'),
    _NavItem(
        icon: Icons.dns_outlined,
        activeIcon: Icons.dns_rounded,
        label: 'Server'),
    _NavItem(
        icon: Icons.settings_outlined,
        activeIcon: Icons.settings,
        label: 'Settings'),
  ];

  bool get _isWide {
    if (kIsWeb) return true;
    return Get.width >= 800;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.checkResumeModel(context);
    });
    return Scaffold(
      backgroundColor: isDark ? AppColors.bg : AppColors.lightBg,
      body: Obx(() {
        final content = IndexedStack(
          index: controller.currentTab.value,
          children: const [
            ChatView(),
            ModelView(),
            ServerView(),
            SettingsView()
          ],
        );
        if (_isWide) {
          return Row(children: [
            _buildSidebar(context, isDark),
            VerticalDivider(
                width: 0.5,
                thickness: 0.5,
                color: isDark
                    ? Colors.white.withValues(alpha: 0.08)
                    : Colors.black.withValues(alpha: 0.08)),
            Expanded(child: content),
          ]);
        }
        return content;
      }),
      bottomNavigationBar:
          _isWide ? null : Obx(() => _buildBottomNav(context, isDark)),
    );
  }

  Widget _buildBottomNav(BuildContext context, bool isDark) {
    final selected = controller.currentTab.value;
    const accent = AppColors.primary;

    return SafeArea(
      top: false,
      minimum: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: isDark
                  ? Colors.black.withValues(alpha: 0.45)
                  : accent.withValues(alpha: 0.10),
              blurRadius: 28,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(28),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
            child: Container(
              height: 66,
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: isDark
                      ? [
                          Colors.white.withValues(alpha: 0.10),
                          Colors.white.withValues(alpha: 0.045),
                        ]
                      : [
                          Colors.white.withValues(alpha: 0.94),
                          Colors.white.withValues(alpha: 0.74),
                        ],
                ),
                borderRadius: BorderRadius.circular(28),
                border: Border.all(
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.12)
                      : Colors.black.withValues(alpha: 0.06),
                  width: 0.8,
                ),
              ),
              child: Row(
                children: [
                  for (var i = 0; i < _tabs.length; i++)
                    Expanded(
                      child: _DockItem(
                        tab: _tabs[i],
                        selected: selected == i,
                        isDark: isDark,
                        onTap: () {
                          if (selected == i) return;
                          HapticFeedback.selectionClick();
                          controller.changeTab(i);
                        },
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSidebar(BuildContext context, bool isDark) {
    const accent = AppColors.primary;
    final muted = Theme.of(context).hintColor;

    return Container(
      width: 76,
      color: isDark ? AppColors.bg : AppColors.lightBg,
      child: Column(children: [
        const SizedBox(height: 16),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.asset(
            'assets/icons/appicon.png',
            width: 40,
            height: 40,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(height: 12),
        Expanded(child: Obx(() {
          final current = controller.currentTab.value;
          return ListView.builder(
            itemCount: _tabs.length,
            itemBuilder: (_, i) {
              final tab = _tabs[i];
              final sel = current == i;
              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                child: Material(
                  color:
                      sel ? accent.withValues(alpha: 0.12) : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () => controller.changeTab(i),
                    child: SizedBox(
                      height: 52,
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(sel ? tab.activeIcon : tab.icon,
                                color: sel ? accent : muted, size: 20),
                            const SizedBox(height: 3),
                            Text(tab.label,
                                style: GoogleFonts.inter(
                                    fontSize: 10,
                                    fontWeight:
                                        sel ? FontWeight.w600 : FontWeight.w400,
                                    color: sel ? accent : muted)),
                          ]),
                    ),
                  ),
                ),
              );
            },
          );
        })),
        const SizedBox(height: 16),
      ]),
    );
  }
}

class _NavItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  const _NavItem(
      {required this.icon, required this.activeIcon, required this.label});
}

class _DockItem extends StatelessWidget {
  const _DockItem({
    required this.tab,
    required this.selected,
    required this.isDark,
    required this.onTap,
  });

  final _NavItem tab;
  final bool selected;
  final bool isDark;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    const accent = AppColors.primary;
    final muted = Theme.of(context).hintColor;

    return Semantics(
      button: true,
      selected: selected,
      label: tab.label,
      excludeSemantics: true,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOutCubic,
          margin: const EdgeInsets.symmetric(horizontal: 1),
          decoration: BoxDecoration(
            color: selected && !isDark
                ? accent.withValues(alpha: 0.10)
                : Colors.transparent,
            gradient: selected && isDark
                ? LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      accent.withValues(alpha: 0.24),
                      accent.withValues(alpha: 0.10),
                    ],
                  )
                : null,
            borderRadius: BorderRadius.circular(22),
            border: selected
                ? Border.all(
                    color: accent.withValues(alpha: isDark ? 0.28 : 0.16),
                    width: 0.8,
                  )
                : null,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedScale(
                scale: selected ? 1.08 : 1.0,
                duration: const Duration(milliseconds: 220),
                curve: Curves.easeOutCubic,
                child: Icon(
                  selected ? tab.activeIcon : tab.icon,
                  size: 21,
                  color: selected ? accent : muted,
                ),
              ),
              const SizedBox(height: 3),
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 220),
                curve: Curves.easeOutCubic,
                style: GoogleFonts.inter(
                  fontSize: 10,
                  height: 1.0,
                  fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                  color: selected ? accent : muted,
                ),
                child: Text(
                  tab.label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
