import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'locale/app_localization.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  AppLocalizationDelegate _localeOverrideDelegate =
  AppLocalizationDelegate(Locale('en', 'US'));

  _getLanguageKey() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print('${prefs.getString('languageCode')} , ${prefs.getString('countryCode')}');
    String languageCode = prefs.getString('languageCode');
    String countryCode = prefs.getString('countryCode');
    if(languageCode != null || countryCode != null){
      return Locale(languageCode,countryCode);
    }else{
      return null;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getLanguageKey().then((locale){
      setState(() {
        if(locale  != null) AppLocalization.load(locale);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        _localeOverrideDelegate
      ],
      supportedLocales: [
        const Locale('en','US'),
        const Locale('mm','MM')
      ],
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              '${AppLocalization.of(context).heyWorld} , ${AppLocalization.of(context).goodMorning}',
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            Text(
              '${AppLocalization.of(context).sayHello}',
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            RaisedButton(
              color: Colors.blue,
              onPressed: (){
                setState(() {
                  AppLocalization.load(Locale('en','US'));
                  _setLanguageKey('en','US');
                });
              },
              child: Text(
                'English',
                style: TextStyle(
                  color: Colors.white
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            RaisedButton(
              color: Colors.blue,
              onPressed: (){
                setState(() {
                  AppLocalization.load(Locale('mm','MM'));
                  _setLanguageKey('mm','MM');
                });
              },
              child: Text(
                'Myanmar',
                style: TextStyle(
                    color: Colors.white
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  _setLanguageKey(_languageCode,_countryCode) async {
    print('_languageCode $_languageCode , _countryCode $_countryCode');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('languageCode', '$_languageCode');
    await prefs.setString('countryCode', '$_countryCode');
  }
}
