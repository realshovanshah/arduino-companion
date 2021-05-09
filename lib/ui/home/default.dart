import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:smart_dustbin/models/image_model.dart';
import 'package:smart_dustbin/services/auth_service.dart';
import 'package:smart_dustbin/services/dustbin_service.dart';

class DefaultScreen extends StatelessWidget {
  DefaultScreen({Key key, this.firebaseRef}) : super(key: key);
  // Future<ImageModel> imageModel;
  final DatabaseReference firebaseRef;
  @override
  Widget build(BuildContext context) {
    // imageModel = getDustbin();
    // print(imageModel);
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              AuthService(FirebaseAuth.instance).signOut();
            },
          )
        ],
      ),
      body: Center(
        child: FutureBuilder<ImageModel>(
            future: ImageService.getDustbin(firebaseRef),
            builder: (context, snapshot) {
              return (!snapshot.hasData)
                  ? CircularProgressIndicator()
                  : Container(
                      constraints: BoxConstraints.expand(),
                      color: Theme.of(context).accentColor.withOpacity(0.3),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Your Dustbin!',
                            style: TextStyle(fontSize: 36),
                          ),
                          SizedBox(height: 75),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Image.network(
                              "https://firebasestorage.googleapis.com/v0/b/dustbin-72bd0.appspot.com/o/dustbins%2Fhappy-blue-recycle-bin-cartoon-260nw-389946562.jpg?alt=media&token=adb78437-0ef5-4702-9b5b-538bf7eee6f1",
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Fill status: ",
                                  style: TextStyle(fontSize: 17),
                                ),
                                Text(
                                  snapshot.data.isOpen.toString(),
                                  style: TextStyle(fontSize: 20),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Lid Open: ",
                                  style: TextStyle(fontSize: 17),
                                ),
                                Text(
                                  snapshot.data.fillStatus,
                                  style: TextStyle(fontSize: 20),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Is Full: ",
                                  style: TextStyle(fontSize: 17),
                                ),
                                Text(
                                  snapshot.data.fillStatus,
                                  style: TextStyle(fontSize: 20),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
            }),
      ),
    );
  }
}
