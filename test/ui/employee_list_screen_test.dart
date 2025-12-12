
import 'package:flutter/material.dart';
import 'package:flutter_project/models/user_model.dart';
import 'package:flutter_project/providers/employee_provider.dart';
import 'package:flutter_project/providers/language_provider.dart';
import 'package:flutter_project/screens/employee_list_screen.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import '../mocks.dart';

void main() {
  late MockEmployeeProvider mockEmployeeProvider;
  late MockLanguageProvider mockLanguageProvider;

  setUp(() {
    mockEmployeeProvider = MockEmployeeProvider();
    mockLanguageProvider = MockLanguageProvider();
  });

  Widget createEmployeeListScreen() {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<EmployeeProvider>.value(value: mockEmployeeProvider),
        ChangeNotifierProvider<LanguageProvider>.value(value: mockLanguageProvider),
      ],
      child: const MaterialApp(
        home: Scaffold(
          body: EmployeeListContent(userId: 'test_user'),
        ),
      ),
    );
  }

  testWidgets('Employee list shows empty state when no data', (WidgetTester tester) async {
    await tester.pumpWidget(createEmployeeListScreen());
    await tester.pump(); 

    expect(find.text('No Employees'), findsOneWidget);
  });

  testWidgets('Employee list shows employees when data is available', (WidgetTester tester) async {
    final employees = [
      UserModel(
        uid: 'u1',
        displayName: 'John Doe',
        email: 'john@test.com',
        phone: '123456789',
        department: Department.it,
        position: 'Developer',
        baseSalary: 1000,
        hireDate: DateTime.now(),
        status: 'Active',
        role: UserRole.employee,
        createdAt: DateTime.now(),
      ),
      UserModel(
        uid: 'u2',
        displayName: 'Jane Smith',
        email: 'jane@test.com',
        phone: '987654321',
        department: Department.hr,
        position: 'Recruiter',
        baseSalary: 1200,
        hireDate: DateTime.now(),
        status: 'Active',
        role: UserRole.employee,
        createdAt: DateTime.now(),
      ),
    ];

    mockEmployeeProvider.setEmployees(employees);

    await tester.pumpWidget(createEmployeeListScreen());
    await tester.pump();

    expect(find.text('John Doe'), findsOneWidget);
    expect(find.text('Jane Smith'), findsOneWidget);
    expect(find.text('Developer'), findsOneWidget);
  });

  testWidgets('Search filters employees', (WidgetTester tester) async {
    final employees = [
      UserModel(
        uid: 'u1',
        displayName: 'John Doe',
        email: 'john@test.com',
        phone: '123456789',
        department: Department.it,
        position: 'Developer',
        baseSalary: 1000,
        hireDate: DateTime.now(),
        status: 'Active',
        role: UserRole.employee,
        createdAt: DateTime.now(),
      ),
      UserModel(
        uid: 'u2',
        displayName: 'Jane Smith',
        email: 'jane@test.com',
        phone: '987654321',
        department: Department.hr,
        position: 'Recruiter',
        baseSalary: 1200,
        hireDate: DateTime.now(),
        status: 'Active',
        role: UserRole.employee,
        createdAt: DateTime.now(),
      ),
    ];
    mockEmployeeProvider.setEmployees(employees);

    await tester.pumpWidget(createEmployeeListScreen());
    await tester.pump();

    expect(find.text('John Doe'), findsOneWidget);
    expect(find.text('Jane Smith'), findsOneWidget);

    final searchField = find.byType(TextField);
    await tester.enterText(searchField, 'John');
    await tester.pump();

    expect(find.text('John Doe'), findsOneWidget);
    expect(find.text('Jane Smith'), findsNothing);
  });

  testWidgets('Sorts employees by Salary', (WidgetTester tester) async {
    final employees = [
      UserModel(
        uid: 'u1',
        displayName: 'Alice',
        email: 'alice@test.com',
        phone: '111',
        department: Department.it,
        position: 'Dev',
        baseSalary: 2000, // Higher salary
        hireDate: DateTime.now(),
        status: 'Active',
        role: UserRole.employee,
        createdAt: DateTime.now(),
      ),
      UserModel(
        uid: 'u2',
        displayName: 'Bob',
        email: 'bob@test.com',
        phone: '222',
        department: Department.it,
        position: 'Dev',
        baseSalary: 1000, // Lower salary
        hireDate: DateTime.now(),
        status: 'Active',
        role: UserRole.employee,
        createdAt: DateTime.now(),
      ),
    ];
    mockEmployeeProvider.setEmployees(employees);

    await tester.pumpWidget(createEmployeeListScreen());
    await tester.pump();

    // Open Sort Dialog
    await tester.tap(find.byIcon(Icons.sort));
    await tester.pumpAndSettle();

    // Select 'Salary'
    await tester.tap(find.text('Salary'));
    await tester.pumpAndSettle();
    
    // Select 'Descending'
    await tester.tap(find.text('Descending'));
    await tester.pumpAndSettle();

    // Close bottom sheet
    await tester.pageBack();
    await tester.pumpAndSettle();
  });

  testWidgets('Filters employees by Department', (WidgetTester tester) async {
    final employees = [
      UserModel(
        uid: 'u1',
        displayName: 'IT Guy',
        email: 'it@test.com',
        phone: '111',
        department: Department.it,
        position: 'Dev',
        baseSalary: 1000, 
        hireDate: DateTime.now(),
        status: 'Active',
        role: UserRole.employee,
        createdAt: DateTime.now(),
      ),
      UserModel(
        uid: 'u2',
        displayName: 'HR Girl',
        email: 'hr@test.com',
        phone: '222',
        department: Department.hr,
        position: 'Recruiter',
        baseSalary: 1000, 
        hireDate: DateTime.now(),
        status: 'Active',
        role: UserRole.employee,
        createdAt: DateTime.now(),
      ),
    ];
    mockEmployeeProvider.setEmployees(employees);

    await tester.pumpWidget(createEmployeeListScreen());
    await tester.pump();

    // Verify both actally exist
    expect(find.text('IT Guy'), findsOneWidget);
    expect(find.text('HR Girl'), findsOneWidget);

    // Open Filter Dialog
    await tester.tap(find.byIcon(Icons.filter_list));
    await tester.pumpAndSettle();

    // Select 'IT' chip
    await tester.tap(find.widgetWithText(FilterChip, 'IT'));
    await tester.pumpAndSettle();

    // Close dialog
    // await tester.tapAt(const Offset(10, 10)); // Tap outside
    await tester.pageBack();
    await tester.pumpAndSettle();

    // Verify only IT Guy exists
    expect(find.text('IT Guy'), findsOneWidget);
    expect(find.text('HR Girl'), findsNothing);
  });
}
