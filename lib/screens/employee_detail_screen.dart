import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart' hide AuthProvider;
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';
import '../providers/employee_provider.dart';
import '../providers/auth_provider.dart';
import '../services/backend_api_service.dart';
import '../theme/app_theme.dart';

class EmployeeDetailScreen extends StatefulWidget {
  final UserModel? employee;
  final bool isEditMode;

  const EmployeeDetailScreen({
    super.key,
    this.employee,
    this.isEditMode = false,
  });

  @override
  State<EmployeeDetailScreen> createState() => _EmployeeDetailScreenState();
}

class _EmployeeDetailScreenState extends State<EmployeeDetailScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _positionController;
  late TextEditingController _salaryController;
  Department _selectedDepartment = Department.it;
  UserRole _selectedRole = UserRole.employee;
  String _selectedStatus = 'Active';
  DateTime _selectedDate = DateTime.now();
  bool _isLoading = false;

  final List<String> statusOptions = ['Active', 'OnLeave', 'Terminated'];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.employee?.displayName ?? '');
    _emailController = TextEditingController(text: widget.employee?.email ?? '');
    _phoneController = TextEditingController(text: widget.employee?.phone ?? '');
    _positionController = TextEditingController(text: widget.employee?.position ?? '');
    _salaryController = TextEditingController(text: widget.employee?.baseSalary.toString() ?? '');


    if (widget.employee != null) {
      _selectedDepartment = widget.employee!.department;
      _selectedRole = widget.employee!.role;
      _selectedStatus = widget.employee!.status;
      if (!statusOptions.contains(_selectedStatus)) {
          _selectedStatus = 'Active'; 
      }
      _selectedDate = widget.employee!.hireDate ?? DateTime.now();
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _positionController.dispose();
    _salaryController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = context.read<AuthProvider>().user;
    final isAdmin = currentUser?.role == UserRole.admin;

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: Text(widget.isEditMode ? 'Edit Employee' : 'Add Employee'),
        backgroundColor: AppTheme.primaryColor,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: Theme.of(context).textTheme.titleLarge?.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          if (widget.isEditMode)
            IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.white),
              onPressed: _deleteEmployee,
            ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (widget.isEditMode)
                       Center(
                         child: Padding(
                           padding: const EdgeInsets.only(bottom: 24),
                           child: CircleAvatar(
                             radius: 50,
                             backgroundColor: AppTheme.primaryColor.withValues(alpha: 0.1),
                             child: Text(
                               (widget.employee?.displayName ?? '?').substring(0, 1).toUpperCase(),
                               style: const TextStyle(fontSize: 40, color: AppTheme.primaryColor, fontWeight: FontWeight.bold),
                             ),
                           ),
                         ),
                       ),
                    
                    _buildSectionTitle('Personal Information'),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            TextFormField(
                              controller: _nameController,
                              decoration: const InputDecoration(
                                labelText: 'Full Name',
                                prefixIcon: Icon(Icons.person_outline),
                              ),
                              validator: (value) => value!.isEmpty ? 'Required' : null,
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _emailController,
                              decoration: const InputDecoration(
                                labelText: 'Email',
                                prefixIcon: Icon(Icons.email_outlined),
                              ),
                              keyboardType: TextInputType.emailAddress,
                              enabled: !widget.isEditMode, // Prevent changing email as it's linked to Auth
                              validator: (value) => value!.isEmpty ? 'Required' : null,
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _phoneController,
                              decoration: const InputDecoration(
                                labelText: 'Phone',
                                prefixIcon: Icon(Icons.phone_outlined),
                              ),
                              keyboardType: TextInputType.phone,
                              validator: (value) => value!.isEmpty ? 'Required' : null,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    _buildSectionTitle('Job Details'),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            TextFormField(
                              controller: _positionController,
                              decoration: const InputDecoration(
                                labelText: 'Position',
                                prefixIcon: Icon(Icons.work_outline),
                              ),
                              validator: (value) => value!.isEmpty ? 'Required' : null,
                            ),
                            const SizedBox(height: 16),
                            DropdownButtonFormField<Department>(
                              value: _selectedDepartment,
                              decoration: const InputDecoration(
                                labelText: 'Department',
                                prefixIcon: Icon(Icons.business_outlined),
                              ),
                              items: Department.values.map((dept) {
                                return DropdownMenuItem(
                                  value: dept,
                                  child: Text(dept.name.toUpperCase()),
                                );
                              }).toList(),
                              onChanged: (value) => setState(() => _selectedDepartment = value!),
                            ),
                            const SizedBox(height: 16),
                            DropdownButtonFormField<String>(
                              value: _selectedStatus,
                              decoration: const InputDecoration(
                                labelText: 'Status',
                                prefixIcon: Icon(Icons.flag_outlined),
                              ),
                              items: statusOptions.map((status) {
                                return DropdownMenuItem(
                                  value: status,
                                  child: Text(status),
                                );
                              }).toList(),
                              onChanged: (value) => setState(() => _selectedStatus = value!),
                            ),
                            const SizedBox(height: 16),
                            InkWell(
                              onTap: () => _selectDate(context),
                              child: InputDecorator(
                                decoration: const InputDecoration(
                                  labelText: 'Hire Date',
                                  prefixIcon: Icon(Icons.calendar_today_outlined),
                                ),
                                child: Text(
                                  '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                                  style: const TextStyle(fontSize: 16, color: AppTheme.textPrimary),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                     _buildSectionTitle('Compensation'),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: TextFormField(
                          controller: _salaryController,
                          decoration: const InputDecoration(
                            labelText: 'Basic Salary',
                            prefixIcon: Icon(Icons.attach_money),
                            suffixText: 'VNĐ',
                          ),
                          keyboardType: TextInputType.number,
                          validator: (value) => value!.isEmpty ? 'Required' : null,
                        ),
                      ),
                    ),
                    
                    if (isAdmin) ...[
                      const SizedBox(height: 24),
                      _buildSectionTitle('Role Management (Admin)'),
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: DropdownButtonFormField<UserRole>(
                            value: _selectedRole,
                            decoration: const InputDecoration(
                              labelText: 'Role',
                              prefixIcon: Icon(Icons.security),
                            ),
                            items: UserRole.values.map((role) {
                              return DropdownMenuItem(
                                value: role,
                                child: Text(role.name.toUpperCase()),
                              );
                            }).toList(),
                            onChanged: (value) => setState(() => _selectedRole = value!),
                          ),
                        ),
                      ),
                    ],



                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: _saveEmployee,
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        ),
                        child: Text(
                          widget.isEditMode ? 'Update Employee' : 'Save Employee',
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.bold,
          color: AppTheme.textSecondary,
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: AppTheme.lightTheme.copyWith(
            colorScheme: const ColorScheme.light(primary: AppTheme.primaryColor),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() => _selectedDate = picked);
    }
  }

  Future<void> _saveEmployee() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      try {
        final currentUserId = FirebaseAuth.instance.currentUser?.uid;
        if (currentUserId == null) throw Exception('User not logged in');

        String employeeUserId;
        
        if (widget.isEditMode) {
            employeeUserId = widget.employee!.uid;
        } else {
            // Creation Mode - Just generate an ID for Firestore
            employeeUserId = FirebaseFirestore.instance.collection('users').doc().id;
        }

        // Create UserModel
        final employee = UserModel(
          uid: employeeUserId,
          email: _emailController.text,
          displayName: _nameController.text,
          role: _selectedRole,
          department: _selectedDepartment,
          createdAt: widget.employee?.createdAt ?? DateTime.now(), // Preserve creation date if editing
          phone: _phoneController.text,
          baseSalary: double.parse(_salaryController.text),
          hireDate: _selectedDate,
          status: _selectedStatus,
          position: _positionController.text,
        );

        final provider = context.read<EmployeeProvider>();
        if (widget.isEditMode) {
          await provider.updateEmployee(employee);
        } else {
          await provider.addEmployee(employee);
        }

        if (mounted) Navigator.pop(context);
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
          );
        }
      } finally {
        if (mounted) setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _deleteEmployee() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Employee'),
        content: const Text(
          'Are you sure you want to delete this employee?\nThis action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      setState(() => _isLoading = true);
      try {
        if (!mounted) return;
      final provider = context.read<EmployeeProvider>();
        
        final employeeUserId = widget.employee?.uid;
        final currentAdminId = FirebaseAuth.instance.currentUser?.uid;
        
        // Only delete Auth if it's not the current admin (prevent self-delete in this context)
        // And usually we assume employees have accounts if they are in 'users'
        // But checking Backend health is good practice.
        if (employeeUserId != null && employeeUserId != currentAdminId) {
             final isHealthy = await BackendApiService.checkHealth();
             if (isHealthy) {
                 await BackendApiService.deleteEmployeeAccount(employeeUserId);
             } else {
                 if (mounted) {
                 ScaffoldMessenger.of(context).showSnackBar(
                   const SnackBar(content: Text('Warning: Backend server offline. Auth account not deleted.')),
                 );
             }
             }
        }

        await provider.deleteEmployee(employeeUserId!);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Employee deleted successfully'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context); 
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error deleting: $e'), backgroundColor: Colors.red),
          );
        }
      } finally {
        if (mounted) setState(() => _isLoading = false);
      }
    }
  }
}
