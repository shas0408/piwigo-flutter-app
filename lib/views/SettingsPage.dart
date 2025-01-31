
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:piwigo_ng/views/LoginViewPage.dart';
import 'package:piwigo_ng/api/API.dart';


class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  double _currentSliderValue = 5;
  String _derivative;

  @override
  void initState() {
    super.initState();
    _currentSliderValue = API.prefs.getInt("recent_albums").toDouble();
    _derivative = API.prefs.getString('miniature_size');
  }

  @override
  Widget build(BuildContext context) {
    ThemeData _theme = Theme.of(context);
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            pinned: true,
            snap: false,
            floating: false,
            expandedHeight: 100.0,
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.check, color: _theme.iconTheme.color),
            ),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(),
                // Consumer<ThemeNotifier>(
                //   builder: (context, notifier, child) => Switch(
                //     onChanged:(value){
                //       notifier.toggleTheme();
                //     },
                //     value: notifier.darkTheme,
                //   ),
                // ),
                // TODO: Add tutorials
                //Icon(Icons.info_outline, color: _theme.iconTheme.color),
              ],
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 20),
                    child: Text("Settings", style: TextStyle(fontSize: 26.0, fontWeight: FontWeight.w900, color: Color(0xff000000))),
                  ),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.only(top: 30),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
                  return Container(
                    padding: EdgeInsets.zero,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 10),
                          child: Text('Piwigo Server ${API.prefs.getString('version')}', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18)),
                        ),
                        API.prefs.getString('base_url').substring(0, 4) != 'https' ? Text('') : Padding(
                          padding: EdgeInsets.only(left: 10, bottom: 3),
                          child: Text('Unsecured Website !', style: TextStyle(color: Colors.black, fontSize: 12)),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            border: Border.symmetric(horizontal: BorderSide(width: 0.5, color: Colors.grey)),
                            color: Colors.white,
                          ),
                          child: Column(
                            children: [
                              tableCell(
                                Text('Address', style: TextStyle(color: Colors.black, fontSize: 16)),
                                Text('${API.prefs.getString('base_url')}', overflow: TextOverflow.ellipsis, softWrap: false, style: TextStyle(color: Colors.grey.shade600, fontSize: 14)),
                              ),
                              tableCell(
                                Text('Username', style: TextStyle(color: Colors.black, fontSize: 16)),
                                Text('${API.prefs.getString('account_username')}', overflow: TextOverflow.ellipsis, softWrap: false, style: TextStyle(color: Colors.grey.shade600, fontSize: 14)),
                                isEnd: true,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 20),
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            border: Border.symmetric(horizontal: BorderSide(width: 0.5, color: Colors.grey)),
                            color: Colors.white,
                          ),
                          child: TextButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(Colors.transparent),
                            ),
                            onPressed: () {
                              API.prefs.setBool("is_logged", false);
                              Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                  builder: (BuildContext context) => LoginViewPage(),
                                ),
                                (Route route) => false,
                              );
                            },
                            child: Text('${API.prefs.getBool('is_guest') ? 'Log in' : 'Log out' }', style: TextStyle(color: Color(0xffff7700), fontSize: 20)),
                          ),
                        ),
                        API.prefs.getBool('is_guest') ?
                          Text('') :
                          Center(
                            child: Container(
                              padding: EdgeInsets.all(5),
                              child: Text('This server handles these file types: ${API.prefs.getString("file_types").replaceAll(",", ", ")}', textAlign: TextAlign.center, style: TextStyle(color: Colors.black, fontSize: 12)),
                            ),
                          ),
                        /*
                        // TODO: Implement albums options
                        SizedBox(height: 20),
                        Padding(
                          padding: EdgeInsets.only(left: 10, bottom: 3),
                          child: Text('Albums', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18)),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            border: Border.symmetric(horizontal: BorderSide(width: 0.5, color: Colors.grey)),
                            color: Colors.white,
                          ),
                          child: Column(
                            children: [
                              /*
                              InkWell(
                                onTap: () {
                                  // TODO: Implement change root album
                                  print('change root album');
                                },
                                child: tableCell(
                                  Text('Default Album', style: TextStyle(color: Colors.black, fontSize: 16)),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text('${prefs.getString('default_album')}', overflow: TextOverflow.ellipsis, softWrap: false, style: TextStyle(color: Colors.grey.shade600, fontSize: 14)),
                                      SizedBox(width: 10),
                                      Icon(Icons.chevron_right, color: Colors.grey.shade600, size: 20),
                                    ],
                                  ),
                                ),
                              ),
                               */
                              InkWell(
                                onTap: () {
                                  // TODO: Implement change miniature size
                                  print('change image miniatures size');
                                },
                                child: tableCellEnd(
                                  Text('Miniatures', style: TextStyle(color: Colors.black, fontSize: 16)),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      DropdownButton<String>(
                                        value: _derivative == null ? API.prefs.getString('miniature_size') : _derivative,
                                        style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                                        underline: Container(),
                                        icon: Icon(Icons.chevron_right, color: Colors.grey.shade600, size: 20),
                                        onChanged: (String newValue) {
                                          setState(() {
                                            _derivative = newValue;
                                            API.prefs.setString('miniature_size', _derivative);
                                          });
                                        },
                                        items: API.prefs.getStringList('available_sizes').map<DropdownMenuItem<String>>((
                                            String value) {
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: Text(value),
                                          );
                                        }).toList(),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              /*
                              InkWell(
                                onTap: () {
                                  // TODO: implement change sort method
                                  print('change sort');
                                },
                                child: tableCell(
                                  Text('Sort', style: TextStyle(color: Colors.black, fontSize: 16)),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text('${albumSort[prefs.getInt('sort')]}', overflow: TextOverflow.ellipsis, softWrap: false, style: TextStyle(color: Colors.grey.shade600, fontSize: 14)),
                                      SizedBox(width: 10),
                                      Icon(Icons.chevron_right, color: Colors.grey.shade600, size: 20),
                                    ],
                                  ),
                                ),
                              ),
                               */
                              /*
                              tableCellEnd(
                                Text('Recent Albums', style: TextStyle(color: Colors.black, fontSize: 16)),
                                Expanded(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Slider(
                                            activeColor: Color(0xffff7700),
                                            inactiveColor: Color(0xffeeeeee),
                                            min: 3,
                                            max: 10,
                                            divisions: 7,
                                            value: _currentSliderValue,
                                            onChanged: (value) {
                                              // TODO: implement change number of recent albums
                                              setState(() {
                                                _currentSliderValue = value;
                                              });
                                              prefs.setInt('recent_albums', value.ceil());
                                            }
                                        ),
                                      ),
                                      SizedBox(
                                        width: 40,
                                        child: Text("${_currentSliderValue.toInt()}/10", style: TextStyle(color: Colors.grey.shade600, fontSize: 14), textAlign: TextAlign.end,),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                               */
                            ],
                          ),
                        ),
                        */
                        SizedBox(height: 20),
                        Padding(
                          padding: EdgeInsets.only(left: 10, bottom: 3),
                          child: Text('Images', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18)),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            border: Border.symmetric(horizontal: BorderSide(width: 0.5, color: Colors.grey)),
                            color: Colors.white,
                          ),
                          child: Column(
                            children: [
                              tableCell(
                                Text('Show miniature title', style: TextStyle(color: Colors.black, fontSize: 16)),
                                Switch(
                                  value: API.prefs.getBool('show_miniature_title'),
                                  onChanged: (bool) {
                                    setState(() {
                                      API.prefs.setBool('show_miniature_title', bool);
                                    });
                                  },
                                ),
                              ),
                              tableCell(
                                Text('Portrait image count', style: TextStyle(color: Colors.black, fontSize: 16)),
                                Expanded(
                                  child: Slider(
                                    label: '${API.prefs.getDouble("portrait_image_count").ceil()}/6',
                                    activeColor: Color(0xffff7700),
                                    inactiveColor: Color(0xffeeeeee),
                                    divisions: 5,
                                    min: 1,
                                    max: 6,
                                    value: API.prefs.getDouble("portrait_image_count"),
                                    onChanged: (i) {
                                      setState(() {
                                        print(i.ceilToDouble());
                                        API.prefs.setDouble("portrait_image_count", i.ceilToDouble());
                                      });
                                    },
                                  ),
                                ),
                              ),
                              tableCell(
                                Text('Landscape image count', style: TextStyle(color: Colors.black, fontSize: 16)),
                                Expanded(
                                  child: Slider(
                                    label: '${API.prefs.getDouble("landscape_image_count").ceil()}/10',
                                    activeColor: Color(0xffff7700),
                                    inactiveColor: Color(0xffeeeeee),
                                    divisions: 6,
                                    min: 4.0,
                                    max: 10.0,
                                    value: API.prefs.getDouble("landscape_image_count"),
                                    onChanged: (i) {
                                      setState(() {
                                        print(i.ceilToDouble());
                                        API.prefs.setDouble("landscape_image_count", i.ceilToDouble());
                                      });
                                    },
                                  ),
                                ),
                              ),
                              tableCell(
                                Text('Miniature size', style: TextStyle(color: Colors.black, fontSize: 16)),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    DropdownButton<String>(
                                      value: _derivative == null ? API.prefs.getString('miniature_size') : _derivative,
                                      style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                                      underline: Container(),
                                      icon: Icon(Icons.chevron_right, color: Colors.grey.shade600, size: 20),
                                      onChanged: (String newValue) {
                                        setState(() {
                                          _derivative = newValue;
                                          API.prefs.setString('miniature_size', _derivative);
                                        });
                                      },
                                      items: API.prefs.getStringList('available_sizes').map<DropdownMenuItem<String>>((
                                          String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(value),
                                        );
                                      }).toList(),
                                    ),
                                  ],
                                ),
                                isEnd: true,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
                childCount: 1,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget tableCell(Widget left, Widget right, {List<Widget> options, bool isEnd = false}) {
    return Container(
      height: 40,
      margin: EdgeInsets.only(left: 10),
      padding: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        border: isEnd ? Border.all(width: 0, color: Colors.white) : Border(bottom: BorderSide(width: 0.5, color: Colors.grey)),
        color: Colors.white,
      ),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            left,
            right,
          ] + (options ?? []),
        ),
      ),
    );
  }
}
