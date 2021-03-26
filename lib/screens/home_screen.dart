import 'package:terera/components/dish_widget.dart';
import 'package:terera/constants.dart' as constant;
import 'add_playlist.dart';
import 'login_screen.dart';
import 'package:at_commons/at_commons.dart';
import 'package:terera/service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'other_screen.dart';

class HomeScreen extends StatefulWidget {
  static final String id = 'home';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  final List<DishWidget> sortedWidgets = [];
  ServerDemoService _serverDemoService = ServerDemoService.getInstance();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Welcome, ' + atSign,
        ),
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            children: <Widget>[
              Expanded(
                  child: FutureBuilder(
                future: _scan(),
                builder:
                    (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                  if (snapshot.hasData) {
                    // Returns a list of keys for each dish
                    List<String> dishAttributes = snapshot.data;
                    print(snapshot.data);
                    List<DishWidget> dishWidgets = [];
                    if (dishAttributes.length > 0) {
                      for (String attributes in dishAttributes) {
                        // Look up the string of attributes to a corresponding string of keys
                        List<String> attributesList =
                            attributes.split(constant.splitter);
                        if (attributesList.length >= 3) {
                          DishWidget dishWidget = DishWidget(
                            title: attributesList[0],
                            description: attributesList[1],
                            ingredients: attributesList[2].length == 3
                                ? attributesList[3]
                                : null,
                          );
                          dishWidgets.add(dishWidget);
                        } else {
                          print('The number of attributes is incorrect');
                        }
                      }
                    }
                    return SafeArea(
                      child: ListView(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    'My Playlists',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 32,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  IconButton(
                                    icon: Icon(
                                      Icons.keyboard_arrow_right,
                                    ),
                                    onPressed: () {
                                      Navigator.pushReplacementNamed(
                                          context, OtherScreen.id);
                                    },
                                  )
                                ]),
                          ),
                          Column(
                            children: dishWidgets,
                          ),
                        ],
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Text(
                        'An error has occurred: ' + snapshot.error.toString());
                  } else {
                    return Center(child: CircularProgressIndicator());
                  }
                },
              )),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.pushNamed(context, DishScreen.id)
              .then((value) => setState(() {}));
        },
      ),
    );
  }

  _scan() async {
    List<String> atSignList =
        _serverDemoService.atClientServiceMap.keys.toList();
    print(atSignList);
    List<AtKey> response;
    var regex = '^(?!cached).*cookbook.*';
    for (String atsign in atSignList) {
      if (response == null) {
        response = await _serverDemoService.getAtKeys(regex: regex);
      } else {
        response.addAll(await _serverDemoService.getAtKeys(regex: regex));
      }
    }
    print("response: $response");
    //List<String> scanList = [];
    // if (response.length > 0) {
    //   scanList = response.map((atKey) => atKey.key).toList();
    // }
    // print("scanList: $scanList");
    List<String> responseList = [];
    for (AtKey atKey in response) {
      print("key: $atKey");
      String value = await _lookup(atKey);
      print("value: $value");
      // Appending the title of the dish to the rest of its attributes
      value = atKey.key + constant.splitter + value;
      responseList.add(value);
    }
    return responseList;
  }

  /// Look up a value corresponding to an [AtKey] instance.
  Future<String> _lookup(AtKey atKey) async {
    if (atKey != null) {
      return await _serverDemoService.get(atKey);
    }
    return '';
  }
}
