#!/bin/bash

echo "check and delete android/build folder"

cd android/app && pwd

[  -d "build" ] && echo "build folder found. Deleting build folder" && rm -R build && echo "build deleted"

cd ../.. && pwd

echo "cleaning privo-release-artifacts folder"
rm -r privo-release-artifacts
[ ! -d "privo-release-artifacts" ] && echo "privo-release-artifacts Directory DOES NOT exists. creating directory" && mkdir privo-release-artifacts && echo "Directory Created"

echo "setting up flutter"
flutter clean
flutter pub get

echo "getting version from pubspec.yaml file"
buildVersion=""
file="pubspec.yaml"
i=0
while read -r line; do
i=$((i+1))
test $i = 19 && buildVersion=${line##*+}
done <$file
echo "app version picked from pubspec.yaml file => v$buildVersion"

build_apk() {
  echo "building $1 apk"
  flutter build apk -t lib/main-"$1".dart --flavor "$1"

  echo "copying $1 apk"
  cp build/app/outputs/flutter-apk/app-"$1"-release.apk privo-release-artifacts

  echo "renaming $1 apk with version $buildVersion"
  cd privo-release-artifacts && pwd
  mv app-"$1"-release.apk app-"$1"-release-v"$buildVersion".apk
  cd .. && pwd
}

build_completed_echo(){
  echo "build completed you can find the file in privo-release-artifacts folder"
}

prod_build() {
  build_apk "prod"

  echo "building appbundle"
  flutter build appbundle -t lib/main-prod.dart --flavor prod

  echo "copying prod bundle"
  cp build/app/outputs/bundle/prodRelease/app-prod-release.aab privo-release-artifacts

  echo "renaming prod bundle with version $buildVersion"
  cd privo-release-artifacts && pwd
  mv app-prod-release.aab app-prod-release-v"$buildVersion".aab
  cd .. && pwd
  build_completed_echo
}

if [ "$1" == "low_env" ]
then
  env_list=("qa" "integration" "uat" "dev")
  for env in "${env_list[@]}"
  do
    build_apk "$env"
  done
  build_completed_echo
elif [ "$1" == "prod_bundle" ]
then
  prod_build
else
  build_apk "$1"
  build_completed_echo
fi

