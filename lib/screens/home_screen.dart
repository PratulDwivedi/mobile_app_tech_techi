import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_app_tech_techi/screens/search_screen.dart';
import 'package:mobile_app_tech_techi/widgets/app_bar_menu.dart';
import 'package:mobile_app_tech_techi/widgets/app_drawer.dart';
import 'package:mobile_app_tech_techi/widgets/bottom_navigation_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../providers/riverpod/theme_provider.dart';
import '../providers/riverpod/data_providers.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  int _currentIndex = 0;
  Map<String, dynamic>? _userProfile;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));

    _animationController.forward();
  }

  Future<void> _loadUserProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final profileString = prefs.getString('user_profile');
    if (profileString != null) {
      setState(() {
        _userProfile = json.decode(profileString);
      });
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onBottomNavTap(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeState = ref.watch(themeProvider);
    final isDark = themeState.isDarkMode;
    final primaryColor = ref.watch(primaryColorProvider);
    final userAsync = ref.watch(currentUserProvider);
    final userPagesAsync = ref.watch(userPagesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tech Techi'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: const [
          AppBarMenu(),
        ],
      ),
      drawer: userPagesAsync.when(
        data: (pages) => AppDrawer(pages: pages, userProfile: _userProfile),
        loading: () => const Drawer(child: Center(child: CircularProgressIndicator())),
        error: (error, stack) => Drawer(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text('Error: $error'),
            ),
          ),
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDark
                ? [
                    const Color(0xFF1a1a2e),
                    const Color(0xFF16213e),
                    const Color(0xFF0f3460),
                  ]
                : [
                    primaryColor.withOpacity(0.1),
                    primaryColor.withOpacity(0.05),
                    Colors.white,
                  ],
          ),
        ),
        child: AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10),
                      userAsync.when(
                        data: (user) => user != null ? _buildUserProfileCard(user, primaryColor, isDark) : const SizedBox.shrink(),
                        loading: () => const SizedBox.shrink(),
                        error: (error, stack) => const SizedBox.shrink(),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'App Features',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildFeaturesGrid(primaryColor, isDark),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const SearchScreen(),
            ),
          );
        },
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 8,
        child: const Icon(LucideIcons.search),
      ),
      bottomNavigationBar: userPagesAsync.when(
        data: (pages) => CustomBottomNavigationBar(
          pages: pages,
          currentIndex: _currentIndex,
          onTap: _onBottomNavTap,
        ),
        loading: () => const SizedBox.shrink(),
        error: (error, stack) => const SizedBox.shrink(),
      ),
    );
  }

  Widget _buildUserProfileCard(user, Color primaryColor, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withOpacity(0.1) : Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  primaryColor,
                  primaryColor.withOpacity(0.7),
                ],
              ),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.person, size: 40, color: Colors.white),
          ),
          const SizedBox(height: 16),
          Text(
            user.email?.split('@')[0] ?? 'User',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
          Text(
            user.email ?? 'N/A',
            style: TextStyle(
              fontSize: 16,
              color: isDark ? Colors.white70 : Colors.black54,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturesGrid(Color primaryColor, bool isDark) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 1.2,
      children: [
        _buildFeatureCard('Authentication', 'Secure login with Supabase',
            LucideIcons.shield, Colors.green, isDark),
        _buildFeatureCard('User Management', 'Profile and account settings',
            LucideIcons.users, Colors.blue, isDark),
        _buildFeatureCard('Real-time Sync', 'Live data synchronization',
            LucideIcons.refreshCw, Colors.orange, isDark),
        _buildFeatureCard('Secure Storage', 'Encrypted data protection',
            LucideIcons.lock, Colors.purple, isDark),
      ],
    );
  }

  Widget _buildFeatureCard(String title, String description, IconData icon,
      Color color, bool isDark) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withOpacity(0.1) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
} 