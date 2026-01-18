# Bài tập lớn - Phát triển ứng dụng với Flutter

## Thông tin sinh viên
- **Họ và tên**: Nguyễn Thị Bảo Ngọc
- **MSSV**: 2221050172
- **Lớp**: DCCTCLC67A

---

## Báo cáo kết quả
## Báo cáo kết quả chi tiết

Em đã hoàn thành xây dựng ứng dụng **Quản lý Nhân Viên (Employee Manager)** đáp ứng đầy đủ các yêu cầu của đề tài, từ cơ bản đến nâng cao. Ứng dụng tập trung vào trải nghiệm người dùng mượt mà, bảo mật dữ liệu và kiến trúc mã nguồn sạch.

### 1. Công nghệ & Kiến trúc dự án (Technical Stack)

**Kiến trúc: MVVM (Model - View - ViewModel) kết hợp Provider**
Dự án được tổ chức theo cấu trúc Clean Architecture, tách biệt rõ ràng các tầng:
*   **Models**: Các lớp dữ liệu (`UserModel`, `SalaryModel`) sử dụng `freezed` và `json_serializable` để đảm bảo tính bất biến (immutability) và an toàn khi parse JSON.
*   **Services**: Tầng giao tiếp với Firebase (`AuthService`, `EmployeeService`).
*   **Providers (ViewModel)**: Quản lý trạng thái logic (`AuthProvider`, `EmployeeProvider`), giúp UI chỉ hiển thị dữ liệu mà không chứa logic nghiệp vụ.
*   **Screens (UI)**: Giao diện người dùng được xây dựng bằng các Widget nhỏ, tái sử dụng (`CustomTextField`, `EmployeeCard`).

**Thư viện chính:**
*   `provider`: Quản lý trạng thái hiệu quả.
*   `firebase_auth` & `cloud_firestore`: Backend mạnh mẽ, đồng bộ thời gian thực.
*   `flutter_lints`: Đảm bảo quy chuẩn code sạch của Google.
*   `flutter_test` & `integration_test`: Kiểm thử tự động.

### 2. Các chức năng và Phân quyền (Features & Roles)

Hệ thống phân quyền chi tiết cho 2 nhóm người dùng chính: **Admin/Manager** và **Employee**.

| Chức năng | Admin / Manager | Employee (Nhân viên) |
| :--- | :--- | :--- |
| **Xác thực** | Đăng ký, Đăng nhập, Quên MK, Đổi MK | Đăng nhập, Quên MK, Đổi MK |
| **Quản lý nhân viên** | **CRUD đầy đủ**: Thêm, Sửa, Xóa, Xem danh sách | Chỉ xem thông tin cá nhân của mình |
| **Tìm kiếm & Lọc** | Có thể tìm theo Tên, Phòng ban, Chức vụ | Không khả dụng |
| **Xem hồ sơ** | Xem và cập nhật hồ sơ cá nhân | Xem và cập nhật hồ sơ cá nhân |
| **Quản lý lương** | Xem và điều chỉnh lương cơ bản | Xem mức lương hiện tại (chỉ xem) |

### 3. Quy trình Kiểm thử & Chất lượng (QA & Testing)

Em đã thực hiện quy trình kiểm thử nghiêm ngặt để đảm bảo chất lượng ứng dụng:

**A. Unit Tests (Kiểm thử đơn vị)**
*   Kiểm tra logic của Models: Đảm bảo `fromJson`/`toJson` hoạt động chính xác với mọi trường dữ liệu.
*   Kiểm tra logic Providers: Mô phỏng (`Mock`) các Service để kiểm tra trạng thái đăng nhập/đăng xuất, trạng thái loading khi gọi API.

**B. Widget Tests (Kiểm thử giao diện)**
*   **LoginScreen**: Kiểm tra validation (báo lỗi khi để trống email/password), kiểm tra sự kiện bấm nút Login.
*   **EmployeeListScreen**: Kiểm tra hiển thị đúng số lượng item, kiểm tra chức năng tìm kiếm (danh sách lọc đúng khi nhập text).

**C. Code Analysis (Phân tích mã nguồn)**
*   Chạy lệnh `flutter analyze` trước mỗi lần commit.
*   Kết quả hiện tại: **0 Errors, 0 Warnings, 0 Infos**. Mã nguồn tuân thủ hoàn toàn các quy tắc `lints`.

**D. CI/CD với GitHub Actions**
*   Thiết lập Workflow tự động: Mỗi khi có code mới đẩy lên nhánh `main`, GitHub Actions sẽ tự động kích hoạt.
*   Các bước thực hiện trong pipeline:
    1.  `Setup Flutter`: Cài đặt môi trường Flutter stable mới nhất.
    2.  `Install Dependencies`: Chạy `flutter pub get`.
    3.  `Analyze`: Kiểm tra cú pháp.
    4.  `Run Tests`: Chạy toàn bộ test suite.
    5.  `Build APK`: Thử nghiệm build file cài đặt release để đảm bảo không lỗi build.

### 4. Hướng dẫn cài đặt và chạy ứng dụng

**Bước 1: Tải mã nguồn**
```bash
git clone https://github.com/BaoNgoc2612/flutter-final-project-BaoNgoc2612.git
cd flutter-final-project-BaoNgoc2612
```

**Bước 2: Cài đặt dependencies**
```bash
flutter pub get
```

**Bước 3: Chạy ứng dụng**
Khởi chạy ứng dụng trên máy ảo (Android Emulator) hoặc thiết bị thật:
```bash
flutter run
```

**Bước 4: Kiểm tra kết quả test**
```bash
flutter test
```

### 5. Kết luận & Tự đánh giá

Dự án này không chỉ là một bài tập lớn mà còn là sản phẩm thực tế áp dụng quy trình phát triển phần mềm chuyên nghiệp. Em đã giải quyết thành công các thách thức về **xung đột phiên bản Gradle**, **tích hợp Firebase an toàn** và **thiết lập CI/CD tự động**.

**Tự đánh giá: 10/10**
(Dựa trên các tiêu chí: Build thành công, Code sạch không cảnh báo, Test phủ kín các chức năng quan trọng, UI/UX hoàn thiện và Backend Real-time).
