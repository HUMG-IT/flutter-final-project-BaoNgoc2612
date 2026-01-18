import admin from 'firebase-admin';
import { readFile } from 'fs/promises';
import dotenv from 'dotenv';

dotenv.config();

async function createAdmin() {
    // Initialize Firebase Admin SDK
    let serviceAccount;
    try {
        serviceAccount = JSON.parse(
            await readFile('./serviceAccountKey.json', 'utf8')
        );
    } catch (error) {
        console.error('❌ Error reading serviceAccountKey.json:', error.message);
        process.exit(1);
    }

    if (!admin.apps.length) {
        admin.initializeApp({
            credential: admin.credential.cert(serviceAccount),
            projectId: process.env.FIREBASE_PROJECT_ID || 'flutter-final-762d1', // Fallback to what was in server.js
        });
    }

    const email = 'admin@gmail.com';
    const password = 'admin123';
    const role = 'admin';

    try {
        let userRecord;
        try {
            userRecord = await admin.auth().getUserByEmail(email);
            console.log(`👤 User ${email} exists, updating password...`);
            await admin.auth().updateUser(userRecord.uid, {
                password: password,
                emailVerified: true // Auto-verify admin
            });
        } catch (error) {
            if (error.code === 'auth/user-not-found') {
                console.log(`👤 Creating new admin user ${email}...`);
                userRecord = await admin.auth().createUser({
                    email: email,
                    password: password,
                    displayName: 'Administrator',
                    emailVerified: true,
                });
            } else {
                throw error;
            }
        }

        console.log(`✅ Auth account ready for ${email} (UID: ${userRecord.uid})`);

        // Update Firestore
        const db = admin.firestore();
        const userRef = db.collection('users').doc(userRecord.uid);

        await userRef.set({
            uid: userRecord.uid,
            email: email,
            displayName: 'Administrator',
            role: role,
            department: 'it', // Default department
            status: 'Active',
            position: 'System Administrator',
            baseSalary: 0,
            createdAt: new Date().toISOString(),
            phone: '0000000000',
            hireDate: new Date().toISOString() // Now
        }, { merge: true });

        console.log(`✅ Firestore record updated for ${email} with role: ${role}`);
        console.log(`🎉 Admin setup complete! You can now login with:`);
        console.log(`   Email: ${email}`);
        console.log(`   Password: ${password}`);

    } catch (error) {
        console.error('❌ Error setting up admin:', error);
    } finally {
        process.exit();
    }
}

createAdmin();
