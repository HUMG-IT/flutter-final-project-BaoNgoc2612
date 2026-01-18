import express from 'express';
import cors from 'cors';
import admin from 'firebase-admin';
import { readFile } from 'fs/promises';
import dotenv from 'dotenv';

dotenv.config();

const app = express();
const PORT = process.env.PORT || 3000;

// Middleware
app.use(cors());
app.use(express.json());

// Initialize Firebase Admin SDK
let serviceAccount;
try {
  serviceAccount = JSON.parse(
    await readFile('./serviceAccountKey.json', 'utf8')
  );
} catch (error) {
  console.error('❌ Error reading serviceAccountKey.json:', error.message);
  console.log('📝 Please download your service account key from Firebase Console');
  console.log('   Firebase Console > Project Settings > Service Accounts > Generate New Private Key');
  process.exit(1);
}

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
  projectId: process.env.FIREBASE_PROJECT_ID || 'flutter-final-762d1',
});

console.log('✅ Firebase Admin SDK initialized');

// Health check endpoint
app.get('/health', (req, res) => {
  res.json({ 
    status: 'OK', 
    message: 'HR Management Backend API is running',
    timestamp: new Date().toISOString()
  });
});

// Create employee account endpoint
app.post('/api/employees/create-account', async (req, res) => {
  try {
    const { email, password, displayName, role } = req.body;

    // Validate required fields
    if (!email || !password) {
      return res.status(400).json({
        success: false,
        error: 'Email and password are required',
      });
    }

    // Validate email format
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    if (!emailRegex.test(email)) {
      return res.status(400).json({
        success: false,
        error: 'Invalid email format',
      });
    }

    // Validate password length
    if (password.length < 6) {
      return res.status(400).json({
        success: false,
        error: 'Password must be at least 6 characters',
      });
    }

    // Create user with Firebase Admin SDK (doesn't affect current session)
    const userRecord = await admin.auth().createUser({
      email: email,
      password: password,
      displayName: displayName || '',
      emailVerified: false, // Require email verification
    });

    // Set custom claims for role-based access
    await admin.auth().setCustomUserClaims(userRecord.uid, {
      role: role || 'employee',
    });

    // Generate email verification link
    const verificationLink = await admin
      .auth()
      .generateEmailVerificationLink(email);

    console.log(`✅ Created account for ${email} with UID: ${userRecord.uid}`);

    res.status(201).json({
      success: true,
      uid: userRecord.uid,
      email: userRecord.email,
      displayName: userRecord.displayName,
      message: 'Employee account created successfully',
      verificationLink: verificationLink,
    });
  } catch (error) {
    console.error('❌ Error creating employee account:', error);

    // Handle specific Firebase errors
    if (error.code === 'auth/email-already-exists') {
      return res.status(409).json({
        success: false,
        error: 'Email already exists',
      });
    }

    if (error.code === 'auth/invalid-email') {
      return res.status(400).json({
        success: false,
        error: 'Invalid email address',
      });
    }

    if (error.code === 'auth/weak-password') {
      return res.status(400).json({
        success: false,
        error: 'Password is too weak',
      });
    }

    res.status(500).json({
      success: false,
      error: error.message || 'Internal server error',
    });
  }
});

// Delete employee account endpoint
app.delete('/api/employees/:uid', async (req, res) => {
  try {
    const { uid } = req.params;

    if (!uid) {
      return res.status(400).json({
        success: false,
        error: 'User ID is required',
      });
    }

    await admin.auth().deleteUser(uid);

    console.log(`✅ Deleted account with UID: ${uid}`);

    res.json({
      success: true,
      message: 'Employee account deleted successfully',
    });
  } catch (error) {
    console.error('❌ Error deleting employee account:', error);

    if (error.code === 'auth/user-not-found') {
      return res.status(404).json({
        success: false,
        error: 'User not found',
      });
    }

    res.status(500).json({
      success: false,
      error: error.message || 'Internal server error',
    });
  }
});

// Start server
app.listen(PORT, () => {
  console.log(`🚀 Server is running on http://localhost:${PORT}`);
  console.log(`📡 API endpoint: http://localhost:${PORT}/api/employees/create-account`);
  console.log(`❤️  Health check: http://localhost:${PORT}/health`);
});
