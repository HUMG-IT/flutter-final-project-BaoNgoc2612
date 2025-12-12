import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/employee_provider.dart';
import '../models/employee_model.dart';
import 'employee_detail_screen.dart';
import 'add_salary_screen.dart';
import '../theme/app_theme.dart';
import '../providers/language_provider.dart';

class EmployeeListScreen extends StatelessWidget {
  final String userId;

  const EmployeeListScreen({Key? key, required this.userId}) : super(key: key);

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
  EmployeeStatus? _filterStatus;

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  List<EmployeeModel> _filteredEmployees(List<EmployeeModel> employees) {
    List<EmployeeModel> filtered = employees;

    // 1. Search Filter
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((emp) {
        return emp.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
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
          cmp = a.name.compareTo(b.name);
          break;
        case SortOption.salary:
          cmp = a.salary.compareTo(b.salary);
          break;
        case SortOption.hireDate:
          cmp = a.hireDate.compareTo(b.hireDate);
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
        return StreamBuilder<List<EmployeeModel>>(
          stream: provider.employeesStream,
          builder: (context, snapshot) {
            final isLoading = !snapshot.hasData;
            final employees = snapshot.data ?? [];
            final filteredEmployees = _filteredEmployees(employees);

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
                    icon: Icon(Icons.sort, color: AppTheme.textSecondary),
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
              body: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : filteredEmployees.isEmpty
                      ? _buildEmptyState()
                      : RefreshIndicator(
                          onRefresh: () => provider.loadEmployees(widget.userId),
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

  Widget _buildEmployeeCard(BuildContext context, EmployeeModel employee) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
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
                      color: AppTheme.primaryColor.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        employee.name.isNotEmpty ? employee.name.substring(0, 1).toUpperCase() : '?',
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
                          employee.name,
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
                              employee.status.name.toUpperCase(),
                              employee.status.name == 'active' 
                                  ? Colors.green.shade50 
                                  : Colors.orange.shade50,
                              employee.status.name == 'active' 
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
                              employeeUserId: employee.userId,
                              employeeName: employee.name,
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
              Text('Sort By', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              _buildSortOption(context, 'Name', SortOption.name, setModalState),
              _buildSortOption(context, 'Salary', SortOption.salary, setModalState),
              _buildSortOption(context, 'Hire Date', SortOption.hireDate, setModalState),
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
      groupValue: _sortBy,
      activeColor: AppTheme.primaryColor,
      onChanged: (value) {
        setModalState(() => _sortBy = value!);
        setState(() {});
      },
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
                    selectedColor: AppTheme.primaryColor.withOpacity(0.2),
                    checkmarkColor: AppTheme.primaryColor,
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
              const Text('Status', style: TextStyle(fontWeight: FontWeight.w600, color: Colors.grey)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: EmployeeStatus.values.map((status) {
                  final isSelected = _filterStatus == status;
                  return FilterChip(
                    label: Text(status.name.toUpperCase()),
                    selected: isSelected,
                    onSelected: (selected) {
                      setModalState(() => _filterStatus = selected ? status : null);
                      setState(() {});
                    },
                    selectedColor: AppTheme.primaryColor.withOpacity(0.2),
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
