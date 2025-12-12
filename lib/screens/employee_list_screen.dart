import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/employee_provider.dart';
import '../models/employee_model.dart';
import 'employee_detail_screen.dart';
import 'profile_screen.dart';

class EmployeeListScreen extends StatelessWidget {
  final String userId;

  const EmployeeListScreen({Key? key, required this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<EmployeeProvider>(
      create: (_) => EmployeeProvider(userId: userId),
      child: _EmployeeListContent(userId: userId),
    );
  }
}

class _EmployeeListContent extends StatefulWidget {
  final String userId;

  const _EmployeeListContent({required this.userId});

  @override
  State<_EmployeeListContent> createState() => _EmployeeListContentState();
}

class _EmployeeListContentState extends State<_EmployeeListContent> {
  final searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  List<EmployeeModel> _filteredEmployees(List<EmployeeModel> employees) {
    if (_searchQuery.isEmpty) return employees;

    return employees
        .where(
          (emp) =>
              emp.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              emp.position.toLowerCase().contains(_searchQuery.toLowerCase()),
        )
        .toList();
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
              appBar: AppBar(
                title: const Text('Nhân viên'),
                bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(60),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: searchController,
                      decoration: InputDecoration(
                        hintText: 'Tìm kiếm theo tên hoặc vị trí...',
                        prefixIcon: const Icon(Icons.search),
                        suffixIcon: _searchQuery.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear),
                                onPressed: () {
                                  setState(() {
                                    searchController.clear();
                                    _searchQuery = '';
                                  });
                                },
                              )
                            : null,
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
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
              body: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : filteredEmployees.isEmpty
                  ? _buildEmptyState()
                  : RefreshIndicator(
                      onRefresh: () => provider.loadEmployees(widget.userId),
                      child: ListView.builder(
                        itemCount: filteredEmployees.length,
                        itemBuilder: (context, index) => _buildEmployeeCard(
                          context,
                          filteredEmployees[index],
                        ),
                      ),
                    ),
              bottomNavigationBar: BottomNavigationBar(
                currentIndex: 0,
                onTap: (index) {
                  if (index == 1) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const ProfileScreen()),
                    );
                  }
                },
                items: const [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.list),
                    label: 'Danh sách',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.person),
                    label: 'Hồ sơ',
                  ),
                ],
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const EmployeeDetailScreen(),
                  ),
                ),
                child: const Icon(Icons.add),
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
        children: const [
          Icon(Icons.people_outline, size: 80, color: Colors.grey),
          SizedBox(height: 16),
          Text('Chưa có nhân viên nào', style: TextStyle(fontSize: 18)),
        ],
      ),
    );
  }

  Widget _buildEmployeeCard(BuildContext context, EmployeeModel employee) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        leading: CircleAvatar(
          child: Text(employee.name.substring(0, 1).toUpperCase()),
        ),
        title: Text(employee.name),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(employee.position),
            Text(
              '${employee.department.name.toUpperCase()} - ${employee.status.name.toUpperCase()}',
            ),
          ],
        ),
        trailing: Text('${employee.salary.toStringAsFixed(0)}đ'),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) =>
                EmployeeDetailScreen(employee: employee, isEditMode: true),
          ),
        ),
      ),
    );
  }
}
