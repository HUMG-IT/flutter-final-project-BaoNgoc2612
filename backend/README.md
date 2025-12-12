# HR Management Backend API

Backend server using Node.js + Express + Firebase Admin SDK to create employee accounts without logging out Admin.

## 🚀 Setup Instructions

### 1. Install Node.js

Download and install Node.js from https://nodejs.org/ (version 18 or higher)

### 2. Get Firebase Service Account Key

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Select your project: `flutter-final-762d1`
3. Click **Project Settings** (gear icon)
4. Go to **Service Accounts** tab
5. Click **Generate New Private Key**
6. Save the downloaded JSON file as `serviceAccountKey.json` in the `backend` folder

### 3. Install Dependencies

```powershell
cd backend
npm install
```

### 4. Configure Environment

Copy `.env.example` to `.env`:

```powershell
cp .env.example .env
```

### 5. Run the Server

**Development mode (with auto-reload):**

```powershell
npm run dev
```

**Production mode:**

```powershell
npm start
```

The server will run on `http://localhost:3000`

## 📡 API Endpoints

### Health Check

```
GET http://localhost:3000/health
```

### Create Employee Account

```
POST http://localhost:3000/api/employees/create-account
Content-Type: application/json

{
  "email": "employee@example.com",
  "password": "password123",
  "displayName": "Employee Name",
  "role": "employee"
}
```

**Response:**

```json
{
  "success": true,
  "uid": "firebase-uid",
  "email": "employee@example.com",
  "displayName": "Employee Name",
  "message": "Employee account created successfully",
  "verificationLink": "https://..."
}
```

### Delete Employee Account

```
DELETE http://localhost:3000/api/employees/{uid}
```

## 🔒 Security Notes

- Never commit `serviceAccountKey.json` to version control
- Keep `.env` file secure and never share it
- Use environment variables for production deployment
- Consider adding authentication middleware to protect endpoints

## 🐛 Troubleshooting

### Error: Cannot find module 'firebase-admin'

```powershell
npm install
```

### Error: Cannot read serviceAccountKey.json

Make sure you've downloaded the service account key from Firebase Console and placed it in the `backend` folder.

### Port already in use

Change the PORT in `.env` file to a different port number.
