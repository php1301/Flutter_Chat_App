const functions = require('firebase-functions');
const admin = require('firebase-admin');
// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions
//
// exports.helloWorld = functions.https.onRequest((request, response) => {
//   functions.logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });
admin.initializeApp();
exports.myFunction = functions.firestore
    .document('chats/{message}')
    .onCreate((change, context) => {
        console.log(change.data());
        admin.messaging().sendToTopic('chat', { notification: { 
            title: change.data().username, 
            body: change.data().text, 
            clickAction: 'FLUTTER_NOTIFICATION_CLICK',
            } 
        });
    });