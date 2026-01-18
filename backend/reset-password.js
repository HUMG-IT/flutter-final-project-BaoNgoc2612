import admin from 'firebase-admin';
import { readFile } from 'fs/promises';
import dotenv from 'dotenv';

dotenv.config();

async function resetPassword() {
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
            projectId: process.env.FIREBASE_PROJECT_ID || 'flutter-final-762d1',
        });
    }

    const email = 'admin@gmail.com';
    const newPassword = 'admin123'; // Setting it again to be sure

    try {
        const userRecord = await admin.auth().getUserByEmail(email);
        console.log(`👤 Found user ${email} (UID: ${userRecord.uid})`);

        await admin.auth().updateUser(userRecord.uid, {
            password: newPassword,
            emailVerified: true,
            disabled: false,
        });

        console.log(`✅ Password reset to: ${newPassword}`);
        console.log(`✅ Email verified: true`);
        console.log(`✅ Account enabled: true`);

    } catch (error) {
        console.error('❌ Error:', error);
    } finally {
        process.exit();
    }
}

resetPassword();
