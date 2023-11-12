import 'package:flutter/material.dart';
import 'package:freecell/icons.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:soundpool/soundpool.dart';

import 'widgets/card.dart';

Map pf = {
  'theme': 'greenTheme',
  'back': '',
  'iconsPref': 'ClassicIcons',
  'cardBack': 'White',
  'font': 'JetBrainsMono',
  'timer': true,
  'reverse': false,
  'appbar': 'Black',
  'durationPref': 320,
  'coins': 0,
  'highscore': ['999', '999', '999', '999'],
  'timeboard': ['999', '999', '999', '999'],
  'wins': 0,
  'firstBoot': true,
  'soundPref': false,
  'haptic': true,
  'collected': ['whiteTheme', 'greenTheme', 'darkTheme', 'ChessIcons', 'ClassicIcons'],
  'easterEggs': <String>[]
};

late SharedPreferences prefs;

Duration duration = const Duration(milliseconds: 0);
List<Karta> allCards = [];
List<List<ValueNotifier<List<Karta>>>> allDecks = [];
DateTime dt = DateTime.now();

List<GlobalKey> colKeys = [
  GlobalKey(),
  GlobalKey(),
  GlobalKey(),
  GlobalKey(),
  GlobalKey(),
  GlobalKey(),
  GlobalKey(),
  GlobalKey()
];
List<ValueNotifier<List<Karta>>> deck = [
  ValueNotifier([]),
  ValueNotifier([]),
  ValueNotifier([]),
  ValueNotifier([]),
  ValueNotifier([]),
  ValueNotifier([]),
  ValueNotifier([]),
  ValueNotifier([]),
  ValueNotifier([]),
  ValueNotifier([]),
];

final ValueNotifier<int> count = ValueNotifier(0);
final ValueNotifier<bool> shuffling = ValueNotifier(false);
final ValueNotifier<bool> endScreen = ValueNotifier(false);
final ValueNotifier<bool> theme = ValueNotifier(false);
FileImage? back;

Map<String, List<IconData>> icons = {
  'ClassicIcons': [
    SuitIcons.heart,
    SuitIcons.diamond,
    SuitIcons.spades,
    SuitIcons.clubs,
  ],
  'ChessIcons': [
    ChessIcons.knight,
    ChessIcons.queen,
    ChessIcons.rook,
    ChessIcons.king,
  ],
  'SimpleIcons': [
    Icons.crop_square,
    Icons.favorite,
    Icons.spa,
    Icons.nature,
  ],
  'CircleIcons': [
    Icons.fiber_manual_record_outlined,
    Icons.fiber_manual_record_rounded,
    Icons.fiber_manual_record_outlined,
    Icons.fiber_manual_record_rounded,
  ],
  'NumberIcons': [
    Icons.looks_one,
    Icons.looks_two,
    Icons.looks_3,
    Icons.looks_4,
  ]
};

late int soundId;
late Soundpool pool;

Map<String, Color> backgroundColors = {
  'whiteTheme': Colors.white,
  'frogTheme': const Color(0xFFcbe2d4),
  'greenTheme': const Color(0xFF2b875a),
  'yellowTheme': const Color(0xFFd4be98),
  'pinkTheme': const Color(0xFFFEDBD0),
  'greyTheme': Colors.blueGrey,
  'catTheme': const Color(0xFF282a36),
  'darkTheme': const Color(0xFF121212),
  'brownTheme': const Color(0xFF292828),
  'purpleTheme': const Color(0xFF1d2733),
  'anchorTheme': const Color(0xFF11150D),
  'blackTheme': Colors.black,
};

Map<String, Color> textColors = {
  'whiteTheme': Colors.black,
  'frogTheme': const Color(0xFF374540),
  'greenTheme': Colors.teal.shade900,
  'yellowTheme': const Color(0xFF292828),
  'pinkTheme': const Color(0xFF442C2E),
  'greyTheme': Colors.blueGrey.shade900,
  'catTheme': const Color(0xFFFEDBD0),
  'darkTheme': const Color(0xFFcf6679),
  'brownTheme': const Color(0xFFd4be98),
  'purpleTheme': const Color(0xFF906fff),
  'anchorTheme': const Color(0xFFcbe2d4),
  'blackTheme': Colors.grey.shade300,
};

late BuildContext ctx;
bool animating = false;
bool easterEgg = false;
bool toolbar = true;

List<GlobalKey> keys = [GlobalKey(), GlobalKey(), GlobalKey(), GlobalKey()];

ValueNotifier<int> artInt = ValueNotifier(0);

late double h;
late double w;
late bool p;

ThemeData themeData({
  required Color tc,
  required Color bc,
}) {
  return ThemeData(
    useMaterial3: pf['material3'],
    fontFamily: pf['font'],
    textTheme: TextTheme(
      bodyMedium: TextStyle(fontWeight: FontWeight.bold, color: tc, fontFamily: pf['font']),
      bodyLarge: TextStyle(fontWeight: FontWeight.bold, color: tc, fontFamily: pf['font']),
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: bc,
      contentTextStyle: TextStyle(color: tc, fontWeight: FontWeight.bold),
    ),
    primaryColor: tc,
    inputDecorationTheme: InputDecorationTheme(
      counterStyle: TextStyle(color: tc, fontWeight: FontWeight.bold),
      labelStyle: TextStyle(color: tc, fontWeight: FontWeight.bold),
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: tc, width: 2),
      ),
      focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: tc, width: 2)),
    ),
    dividerColor: tc,
    progressIndicatorTheme: ProgressIndicatorThemeData(color: tc),
    dialogBackgroundColor: bc,
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.black,
      foregroundColor: bc,
      shadowColor: Colors.transparent,
      titleTextStyle: TextStyle(
        fontWeight: FontWeight.bold,
        color: bc,
        fontFamily: pf['font'],
        fontSize: 20,
      ),
    ),
    listTileTheme: ListTileThemeData(
      iconColor: tc,
      style: ListTileStyle.drawer,
    ),
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: bc,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
    ),

    chipTheme: ChipThemeData(
      shape: StadiumBorder(
        side: BorderSide(color: tc, width: 2),
      ),
      checkmarkColor: bc,
      selectedColor: tc,
      shadowColor: Colors.transparent,
      backgroundColor: Colors.transparent,
    ),
    scaffoldBackgroundColor: Colors.black,
    navigationBarTheme: NavigationBarThemeData(backgroundColor: bc),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),
    canvasColor: Colors.transparent,
    cardTheme: CardTheme(
      elevation: 6,
      shadowColor: tc,
      margin: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
      color: tc,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
    //useMaterial3: true,
    iconTheme: IconThemeData(color: tc),
    shadowColor: tc,
    colorScheme: ColorScheme(
      primary: tc,
      onPrimary: bc,
      background: bc,
      onBackground: tc,
      surface: bc,
      onSurface: tc,
      error: tc,
      onError: bc,
      brightness: Brightness.light,
      secondary: tc,
      onSecondary: bc,
    ).copyWith(background: bc).copyWith(background: bc),
  );
}

Map<String, String> art = {
  'The Nanoracks Bishop Airlock': 'http://images-assets.nasa.gov/image/iss067e174422/iss067e174422~orig.jpg',
  'Artemis I Rocket':
      'http://images-assets.nasa.gov/image/KSC-20220630-PH-KLS01_0045/KSC-20220630-PH-KLS01_0045~orig.JPG',
  'Jupiter Great Red Spot': 'http://images-assets.nasa.gov/image/PIA01384/PIA01384~orig.jpg',
  'Approaching Jupiter': 'http://images-assets.nasa.gov/image/PIA21390/PIA21390~orig.jpg',
  'A Sky View of Earth From Suomi NPP':
      'http://images-assets.nasa.gov/image/a-sky-view-of-earth-from-suomi-npp_16611703184_o/a-sky-view-of-earth-from-suomi-npp_16611703184_o~orig.jpg',
  'Moon - North Pole': 'http://images-assets.nasa.gov/image/PIA00126/PIA00126~orig.jpg',
  'iss054e012391': 'http://images-assets.nasa.gov/image/iss054e012391/iss054e012391~orig.jpg',
  'Earth observation taken by Expedition 49 crew':
      'http://images-assets.nasa.gov/image/iss049e009355/iss049e009355~orig.jpg',
  'KSC-00padig034': 'http://images-assets.nasa.gov/image/KSC-00padig034/KSC-00padig034~orig.jpg',
  'Engineering Management Board Tour VAB':
      'http://images-assets.nasa.gov/image/KSC-20170322-PH_SWW01_0046/KSC-20170322-PH_SWW01_0046~orig.JPG',
  'Astronaut Edwin Aldrin': 'http://images-assets.nasa.gov/image/as11-40-5903/as11-40-5903~orig.jpg',
  'iss032e025274': 'http://images-assets.nasa.gov/image/iss032e025274/iss032e025274~orig.jpg',
  'International Space Station': 'http://images-assets.nasa.gov/image/0700860/0700860~orig.jpg',
  'View of Soyuz spacecraft which was part of exhibit':
      'http://images-assets.nasa.gov/image/S73-27666/S73-27666~orig.jpg'
};
