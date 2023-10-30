importScripts('https://www.gstatic.com/firebasejs/8.10.1/firebase-app.js');
importScripts('https://www.gstatic.com/firebasejs/8.10.1/firebase-firestore.js');

const firebaseConfig = {
    authDomain: "undervoltage.firebaseapp.com",
    projectId: "undervoltage",
    storageBucket: "undervoltage.appspot.com",
    messagingSenderId: "963808568802",
    appId: "1:963808568802:web:b9cb1b44dcc8ab50b045bb",
    measurementId: "G-7RMJ54P739"
}

firebase.initializeApp(firebaseConfig);