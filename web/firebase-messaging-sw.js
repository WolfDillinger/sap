importScripts("https://www.gstatic.com/firebasejs/9.8.4/firebase-app.js");
importScripts("https://www.gstatic.com/firebasejs/9.9.2/firebase-messaging.js");

//Using singleton breaks instantiating messaging()
// App firebase = FirebaseWeb.instance.app;


firebase.initializeApp({
    apiKey: "AIzaSyCm5WGc257CJ65kle2ONsBkHWnLL9MmxxY",
    authDomain: "sap-app-45a75.firebaseapp.com",
    databaseURL: "https://sap-app-45a75-default-rtdb.firebaseio.com",
    projectId: "sap-app-45a75",
    storageBucket: "sap-app-45a75.appspot.com",
    messagingSenderId: "1078070960455",
    appId: "1:1078070960455:web:08af15623b4af06399ec62",
    measurementId: "G-KCWXXG3Y9X",
});

const messaging = firebase.messaging();
messaging.setBackgroundMessageHandler(function (payload) {
    const promiseChain = clients
        .matchAll({
            type: "window",
            includeUncontrolled: true
        })
        .then(windowClients => {
            for (let i = 0; i < windowClients.length; i++) {
                const windowClient = windowClients[i];
                windowClient.postMessage(payload);
            }
        })
        .then(() => {
            return registration.showNotification("New Message");
        });
    return promiseChain;
});
self.addEventListener('notificationclick', function (event) {
    console.log('notification received: ', event)
});