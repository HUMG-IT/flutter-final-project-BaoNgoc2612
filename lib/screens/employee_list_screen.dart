import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/employee_provider.dart';
import '../models/user_model.dart';
import 'employee_detail_screen.dart';
import 'add_salary_screen.dart';
import '../theme/app_theme.dart';
import '../providers/language_provider.dart';

class EmployeeListScreen extends StatelessWidget {
  final String userId;

  const EmployeeListScreen({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<EmployeeProvider>(
      create: (_) => EmployeeProvider(userId: userId),
      child: EmployeeListContent(userId: userId),
    );
  }
}

class EmployeeListContent extends StatefulWidget {
  final String userId;

  const EmployeeListContent({required this.userId});

  @override
  State<EmployeeListContent> createState() => _EmployeeListContentState();
}

enum SortOption { name, salary, hireDate }

class _EmployeeListContentState extends State<EmployeeListContent> {
  final searchController = TextEditingController();
  String _searchQuery = '';
  
  // Sort & Filter State
  SortOption _sortBy = SortOption.name;
  bool _sortAscending = true;
  Department? _filterDepartment;
  String? _filterStatus;

  final List<String> statusOptions = ['Active', 'OnLeave', 'Terminated'];

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  List<UserModel> _filteredEmployees(List<UserModel> employees) {
    List<UserModel> filtered = employees;

    // 1. Search Filter
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((emp) {
        final name = emp.displayName ?? '';
        return name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
               emp.position.toLowerCase().contains(_searchQuery.toLowerCase());
      }).toList();
    }

    // 2. Department Filter
    if (_filterDepartment != null) {
      filtered = filtered.where((emp) => emp.department == _filterDepartment).toList();
    }

    // 3. Status Filter
    if (_filterStatus != null) {
      filtered = filtered.where((emp) => emp.status == _filterStatus).toList();
    }

    // 4. Sorting
    filtered.sort((a, b) {
      int cmp = 0;
      switch (_sortBy) {
        case SortOption.name:
          cmp = (a.displayName ?? '').compareTo(b.displayName ?? '');
          break;
        case SortOption.salary:
          cmp = a.baseSalary.compareTo(b.baseSalary);
          break;
        case SortOption.hireDate:
          final dateA = a.hireDate ?? DateTime.now();
          final dateB = b.hireDate ?? DateTime.now();
          cmp = dateA.compareTo(dateB);
          break;
      }
      return _sortAscending ? cmp : -cmp;
    });

    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<EmployeeProvider>(
      builder: (context, provider, child) {
        // We use the stream in provider or just the list exposed
        // Provider now exposes 'employees' list which is updated by stream.
        final employees = provider.employees;
        final filteredEmployees = _filteredEmployees(employees);
        final isLoading = provider.isLoading; // Simplified loading check based on provider state if needed

        return Scaffold(
          backgroundColor: AppTheme.backgroundColor,
          appBar: AppBar(
            title: Consumer<LanguageProvider>(
              builder: (context, lang, _) => Text(lang.getText('employee_list_title')),
            ),
            centerTitle: false,
            backgroundColor: AppTheme.surfaceColor,
            elevation: 0,
            actions: [
              IconButton(
                icon: Icon(
                  Icons.filter_list,
                  color: (_filterDepartment != null || _filterStatus != null) 
                      ? AppTheme.primaryColor 
                      : AppTheme.textSecondary,
                ),
                onPressed: _showFilterDialog,
              ),
              IconButton(
                icon: const Icon(Icons.sort, color: AppTheme.textSecondary),
                onPressed: _showSortDialog,
              ),
              const SizedBox(width: 8),
            ],
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(80),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: Container(
                  decoration: BoxDecoration(
                    color: AppTheme.backgroundColor,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      hintText: Provider.of<LanguageProvider>(context).getText('search_placeholder'),
                      prefixIcon: const Icon(Icons.search, color: AppTheme.textSecondary),
                      suffixIcon: _searchQuery.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear, color: AppTheme.textSecondary),
                              onPressed: () {
                                setState(() {
                                  searchController.clear();
                                  _searchQuery = '';
                                });
                              },
                            )
                          : null,
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value;
                      });
                    },
                  ),
                ),
              ),
            ),
          ),
          body: isLoading && employees.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : filteredEmployees.isEmpty
                  ? _buildEmptyState()
                  : RefreshIndicator(
                      onRefresh: () => provider.loadEmployees(),
                      child: ListView.builder(
                        padding: const EdgeInsets.only(top: 8, bottom: 20),
                        itemCount: filteredEmployees.length,
                        itemBuilder: (context, index) => _buildEmployeeCard(
                          context,
                          filteredEmployees[index],
                        ),
                      ),
                    ),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.people_outline, size: 80, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          Text(
            Provider.of<LanguageProvider>(context).getText('no_employees'),
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey.shade500,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmployeeCard(BuildContext context, UserModel employee) {
    final name = employee.displayName ?? 'Unknown';
    final initial = name.isNotEmpty ? name.substring(0, 1).toUpperCase() : '?';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () {
              final userId = widget.userId;
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ChangeNotifierProvider(
                    create: (_) => EmployeeProvider(userId: userId),
                    child: EmployeeDetailScreen(
                      employee: employee,
                      isEditMode: true,
                    ),
                  ),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        initial,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primaryColor,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          employee.position,
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppTheme.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            _buildBadge(
                              employee.department.name.toUpperCase(),
                              Colors.blue.shade50,
                              Colors.blue.shade700,
                            ),
                            const SizedBox(width: 8),
                            _buildBadge(
                              employee.status.toUpperCase(),
                              employee.status.toLowerCase() == 'active' 
                                  ? Colors.green.shade50 
                                  : Colors.orange.shade50,
                              employee.status.toLowerCase() == 'active' 
                                  ? Colors.green.shade700 
                                  : Colors.orange.shade700,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  PopupMenuButton<String>(
                    icon: const Icon(Icons.more_vert, color: AppTheme.textSecondary),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    onSelected: (value) {
                      if (value == 'edit') {
                        final userId = widget.userId;
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ChangeNotifierProvider(
                              create: (_) => EmployeeProvider(userId: userId),
                              child: EmployeeDetailScreen(
                                employee: employee,
                                isEditMode: true,
                              ),
                            ),
                          ),
                        );
                      } else if (value == 'salary') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => AddSalaryScreen(
                              employeeUserId: employee.uid,
                              employeeName: name,
                            ),
                          ),
                        );
                      }
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'edit',
                        child: Row(
                          children: [
                            Icon(Icons.edit_outlined, size: 20),
                            SizedBox(width: 12),
                            Text('Edit Info'),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'salary',
                        child: Row(
                          children: [
                            Icon(Icons.attach_money, size: 20),
                            SizedBox(width: 12),
                            Text('Add Salary'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBadge(String text, Color bgColor, Color textColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: textColor,
        ),
      ),
    );
  }

  void _showSortDialog() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RadioGroup<SortOption>(
                value: _sortBy,
                onChanged: (val) {
                  if (val != null) {
                    setModalState(() => _sortBy = val);
                    setState(() {});
                  }
                },
                child: Column(
                  children: [
                    Text('Sort By', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 20),
                    _buildSortOption(context, 'Name', SortOption.name, setModalState),
                    _buildSortOption(context, 'Salary', SortOption.salary, setModalState),
                    _buildSortOption(context, 'Hire Date', SortOption.hireDate, setModalState),
                  ],
                ),
              ),
              const Divider(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Order:', style: TextStyle(fontWeight: FontWeight.w600)),
                  ToggleButtons(
                    isSelected: [_sortAscending, !_sortAscending],
                    onPressed: (index) {
                      setModalState(() => _sortAscending = index == 0);
                      setState(() {});
                    },
                    borderRadius: BorderRadius.circular(8),
                    children: const [
                       Padding(padding: EdgeInsets.symmetric(horizontal: 12), child: Text('Ascending')),
                       Padding(padding: EdgeInsets.symmetric(horizontal: 12), child: Text('Descending')),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSortOption(BuildContext context, String label, SortOption option, StateSetter setModalState) {
    return RadioListTile<SortOption>(
      title: Text(label),
      value: option,
      activeColor: AppTheme.primaryColor,
    );
  }

  void _showFilterDialog() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Filters', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                  TextButton(
                    onPressed: () {
                      setModalState(() {
                        _filterDepartment = null;
                        _filterStatus = null;
                      });
                      setState(() {});
                    },
                    child: const Text('Reset'),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              const Text('Department', style: TextStyle(fontWeight: FontWeight.w600, color: Colors.grey)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: Department.values.map((dept) {
                  final isSelected = _filterDepartment == dept;
                  return FilterChip(
                    label: Text(dept.name.toUpperCase()),
                    selected: isSelected,
                    onSelected: (selected) {
                      setModalState(() => _filterDepartment = selected ? dept : null);
                      setState(() {});
                    },
                    selectedColor: AppTheme.primaryColor.withValues(alpha: 0.2),
                    checkmarkColor: AppTheme.primaryColor,
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
              const Text('Status', style: TextStyle(fontWeight: FontWeight.w600, color: Colors.grey)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: statusOptions.map((status) {
                  final isSelected = _filterStatus == status;
                  return FilterChip(
                    label: Text(status.toUpperCase()),
                    selected: isSelected,
                    onSelected: (selected) {
                      setModalState(() => _filterStatus = selected ? status : null);
                      setState(() {});
                    },
                    selectedColor: AppTheme.primaryColor.withValues(alpha: 0.2),
                    checkmarkColor: AppTheme.primaryColor,
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
