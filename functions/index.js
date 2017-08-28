var firebase = require('firebase-functions');

// Import Admin SDK
var admin = require('firebase-admin');
admin.initializeApp(firebase.config().firebase);

// Get a database reference to our posts
var db = admin.database()


// const payload = {
//   notification: {
//     title: 'New event added'
//   }
// };


exports.sendNotification = firebase.database.ref("/production/users/requests/signup")
  .onWrite(event => {

  	const delta = event.data._delta
  	var key = ""
  	// var obj = JSON.parse(delta)
  	// console.log("obj data:", obj);
  	// var keys = Object.keys(obj)
  	// var json = delta[keys[0]]
  	// console.log("keys data:", keys);
  	
  	for(var object in delta) {
  		key = object
  	}
	console.log("key data:", key);
	var ref = db.ref("/production/users/requests/signup/" + key)
  	ref.on("value", function(snapshot) {
  		var val = snapshot.val()
  		var firstName = val["firstName"]
  		var lastName = val["lastName"]

  		var payload = {
	      notification: {
	        title: "Sign Up Request",
	        body: firstName + " " + lastName + " requested to sign up.",
	      }
	    };

	    return admin.messaging().sendToTopic("admin", payload)
    	.then(function(response) {
    		console.log("Successfully sent message:", response);
    	})
    	.catch(function(error) {
    		console.log("Error sending message:", error);
    	});

  		// console.log(snapshot.val())
  	}, function (errorObject) {
  		console.log("The read failed: " + errorObject.code);
	});
  	

 //  	firebase.database.ref("/production/users/requests/signup").child(key).once('value').then(function(snap) {
 //    var snapData = snap.val();
	// console.log("snap data:", snapData);

// var topic = 'notifications_' + messageData.receiverKey;
//     var payload = {
//       notification: {
//         title: "You got a new Message",
//         body: messageData.content,
//       }
//     };
    
//     admin.messaging().sendToTopic(topic, payload)
//         .then(function(response) {
//           console.log("Successfully sent message:", response);
//         })
//         .catch(function(error) {
//           console.log("Error sending message:", error);
//         });
  });


 //  	var payload = {
 //      notification: {
 //        title: "You got a new Message",
 //        body: "Test Test success",
 //      }
 //    };

 //    return admin.messaging().sendToTopic("admin", payload)
 //    	.then(function(response) {
 //    		console.log("Successfully sent message:", response);
 //    	})
 //    	.catch(function(error) {
 //    		console.log("Error sending message:", error);
	// });
