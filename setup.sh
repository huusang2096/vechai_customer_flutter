#!/bin/bash#

flutter_clean() {
  flutter clean;
  flutter pub get;
  flutter pub upgrade;
}

flutter_generate() {
  flutter pub get;
  flutter pub run build_runner build;
}

flutter_generate_delete_conflicting() {
  flutter pub get;
  flutter pub run build_runner build --delete-conflicting-outputs;
}

build_iOS() {
  pod repo update;
  rm ios/Podfile.lock;
  pod install --project-directory=ios;
  flutter build ios --no-codesign;
}

echo "select the option to build ************"
echo "  1) android"
echo "  2) ios"
echo "  3) run build_runner"
echo "  4) run build_runner with delete conflicting"
echo "  5) generate translations"
echo "  6) watch build_runner"

read n
case $n in
  1) echo "android is building...";
     flutter_clean;
     get generate locales assets/locales;
     flutter_generate_delete_conflicting;
     # flutter build apk;
     echo "android build finished";;
  2) echo "ios is building...";
     flutter_clean;
     get generate locales assets/locales;
     flutter_generate_delete_conflicting;
     build_iOS;
     echo "ios build finished";;
  3) echo "starting build_runner...";
     flutter_generate;
     echo "build_runner finished";;
  4) echo "generating...";
     flutter_generate_delete_conflicting;
     echo "build_runner finished";;
  5) get generate locales assets/locales;;
  6) flutter pub get;
     flutter packages pub run build_runner watch ;;
esac