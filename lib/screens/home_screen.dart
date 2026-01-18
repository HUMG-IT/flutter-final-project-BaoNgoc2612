import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/employee_provider.dart';
import '../models/user_model.dart';
import 'employee_list_screen.dart';
import 'employee_detail_screen.dart';
import 'profile_screen.dart';
import 'employee_info_screen.dart';
import 'salary_screen.dart';
import '../theme/app_theme.dart';
import '../providers/language_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        final user = authProvider.user;
        final userId = user?.uid ?? '';
        final userRole = user?.role ?? UserRole.employee;

        // Employee screens
        if (userRole == UserRole.employee) {
          final List<Widget> employeeScreens = [
            const EmployeeInfoScreen(),
            const SalaryScreen(),
            const ProfileScreen(),
          ];

          return Scaffold(
            backgroundColor: AppTheme.backgroundColor,
            body: IndexedStack(
              index: _currentIndex,
              children: employeeScreens,
            ),
            bottomNavigationBar: Consumer<LanguageProvider>(
              builder: (context, lang, _) {
                return _buildBottomNavigationBar(
                  items: [
                    BottomNavigationBarItem(
                      icon: const Icon(Icons.badge_outlined),
                      activeIcon: const Icon(Icons.badge),
                      label: lang.getText('home_tab_info'),
                    ),
                    BottomNavigationBarItem(
                      icon: const Icon(Icons.attach_money_outlined),
                      activeIcon: const Icon(Icons.attach_money),
                      label: lang.getText('home_tab_salary'),
                    ),
                    BottomNavigationBarItem(
                      icon: const Icon(Icons.person_outline),
                      activeIcon: const Icon(Icons.person),
                      label: lang.getText('home_tab_profile'),
                    ),
                  ],
                );
              },
            ),
          );
        }

        // Manager screens (3 tabs: Employees, Salary, Profile)
        if (userRole == UserRole.manager) {
           final List<Widget> managerScreens = [
            EmployeeListScreen(userId: userId, userRole: userRole),
            const SalaryScreen(),
            const ProfileScreen(),
          ];

          return Scaffold(
            backgroundColor: AppTheme.backgroundColor,
            body: IndexedStack(
              index: _currentIndex,
              children: managerScreens,
            ),
            bottomNavigationBar: Consumer<LanguageProvider>(
              builder: (context, lang, _) {
                return _buildBottomNavigationBar(
                  items: [
                    BottomNavigationBarItem(
                      icon: const Icon(Icons.people_outline),
                      activeIcon: const Icon(Icons.people),
                      label: lang.getText('home_tab_employees'),
                    ),
                    BottomNavigationBarItem(
                      icon: const Icon(Icons.attach_money_outlined),
                      activeIcon: const Icon(Icons.attach_money),
                      label: lang.getText('home_tab_salary'),
                    ),
                    BottomNavigationBarItem(
                      icon: const Icon(Icons.person_outline),
                      activeIcon: const Icon(Icons.person),
                      label: lang.getText('home_tab_profile'),
                    ),
                  ],
                );
              },
            ),
             floatingActionButton: _currentIndex == 0
                ? FloatingActionButton(
                    onPressed: () => _addEmployee(context),
                    backgroundColor: AppTheme.primaryColor,
                    tooltip: 'Add Employee',
                    child: const Icon(Icons.add, color: Colors.white),
                  )
                : null,
          );
        }

        // Admin screens (2 tabs: User Management & Profile)
        final List<Widget> screens = [
          EmployeeListScreen(userId: userId, userRole: userRole),
          const ProfileScreen(),
        ];

        return Scaffold(
          backgroundColor: AppTheme.backgroundColor,
          body: IndexedStack(
             index: _currentIndex,
             children: screens,
          ),
          bottomNavigationBar: Consumer<LanguageProvider>(
            builder: (context, lang, _) {
              return _buildBottomNavigationBar(
                items: [
                  BottomNavigationBarItem(
                    icon: const Icon(Icons.people_outline),
                    activeIcon: const Icon(Icons.people),
                    label: lang.getText('home_tab_employees'),
                  ),
                  BottomNavigationBarItem(
                    icon: const Icon(Icons.person_outline),
                    activeIcon: const Icon(Icons.person),
                    label: lang.getText('home_tab_profile'),
                  ),
                ],
              );
            },
          ),
          floatingActionButton: _currentIndex == 0
              ? FloatingActionButton(
                  onPressed: () => _addEmployee(context),
                  backgroundColor: AppTheme.primaryColor,
                  tooltip: 'Add Employee',
                  child: const Icon(Icons.add, color: Colors.white),
                )
              : null,
        );
      },
    );
  }

  Widget _buildBottomNavigationBar({required List<BottomNavigationBarItem> items}) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: items,
        selectedItemColor: AppTheme.primaryColor,
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.white,
        elevation: 0,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
        unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500, fontSize: 12),
      ),
    );
  }

  void _addEmployee(BuildContext context) {
    final user = context.read<AuthProvider>().user;
    final userId = user?.uid ?? '';
    final userRole = user?.role ?? UserRole.employee;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChangeNotifierProvider(
          create: (_) => EmployeeProvider(userId: userId, viewerRole: userRole),
          child: const EmployeeDetailScreen(isEditMode: false),
        ),
      ),
    );
  }
}
