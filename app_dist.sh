#!/bin/sh

clear_and_print() {
  clear
  if [ -n "$selected_platform" ]; then
    echo "Selected Platform: \033[1m$selected_platform\033[0m"
  fi

  if [ ${#selected_environments[@]} -ne 0 ]; then
    selected_environments_string=$(
      IFS=,
      echo "${selected_environments[*]}"
    )
    echo "Selected Environments: \033[1m$selected_environments_string\033[0m"
  fi

  if [ -n "$release_notes" ]; then
    echo "Release Notes: \033[1m$release_notes\033[0m"
  fi

  if [ -n "$selected_test_group" ]; then
    echo "Selected Test Groups: \033[1m$selected_test_group\033[0m"
  fi

  if [ ${#successfull_builds[@]} -ne 0 ]; then
    successfull_builds_string=$(
      IFS=,
      echo "${successfull_builds[*]}"
    )
    echo "Successful Builds: \033[1m$successfull_builds_string\033[0m"
  fi

  if [ ${#successfull_uploads[@]} -ne 0 ]; then
    successfull_uploads_string=$(
      IFS=,
      echo "${successfull_uploads[*]}"
    )
    echo "Successful Uploads: \033[1m$successfull_uploads_string\033[0m"
  fi

}

# $1 platform
# $2 environment
get_firebase_app_id() {
  if [ "$1" == "apk" ]; then
    case "$2" in
    "qa")
      app_id="1:726639982263:android:e95aa1d5397cddce487f32"
      ;;
    "integration")
      app_id="1:726639982263:android:1f8f3ab31518eff7487f32"
      ;;
    "dev")
      app_id="1:726639982263:android:f82e5810e2d8a70b487f32"
      ;;
    "uat")
      app_id="1:726639982263:android:f8c30bd106c4c4f7487f32"
      ;;
    esac
  else
    case "$2" in
    "qa")
      app_id="1:726639982263:ios:09f98692017732f2487f32"
      ;;
    "integration")
      app_id="1:726639982263:ios:ebe92f7dba06c9ab487f32"
      ;;
    "dev")
      app_id="1:726639982263:ios:ac6f83df871bc32d487f32"
      ;;
    "uat")
      app_id="1:726639982263:ios:c17e04a9e557898b487f32"
      ;;
    esac
  fi
  firebase_app_id="$app_id"
}

# $1 build file path
# $2 platform
# $3 environment
firebase_upload() {
  clear_and_print
  get_firebase_app_id "$2" "$3"
  # Get the current timestamp
  current_timestamp=$(date +"%d-%m-%Y %I:%M %p")
  firebase appdistribution:distribute "$1" \
    --app "$firebase_app_id" \
    --release-notes "$release_notes. $current_timestamp" --groups "$selected_test_group"
  successfull_uploads+=("$2 $3")
  clear_and_print
}

# $1 env
build_ios() {
  flutter clean
  flutter build ios --release -t lib/main-"$1".dart --flavor "$1"
  echo "Creating .ipa file"
  cd build/ios/iphoneos/
  mkdir -p Payload
  cp -r Runner.app Payload/
  zip -r Payload.zip Payload
  mv Payload.zip Payload.ipa
  rm -rf Payload
  cd ../../..
  successfull_builds+=("ipa $1")
  clear_and_print
  firebase_upload build/ios/iphoneos/Payload.ipa "ios" "$1"
}

# $1 env
build_apk() {
  flutter clean
  flutter build apk -t lib/main-"$1".dart --flavor "$1"
  successfull_builds+=("apk $1")
  clear_and_print
  firebase_upload build/app/outputs/flutter-apk/app-"$1"-release.apk "apk" "$1"
}

check_env_for_build() {
  clear_and_print
  for env in "${selected_environments[@]}"; do
    case "$selected_platform" in
    "both")
      build_apk "$env"
      build_ios "$env"
      ;;
    "android")
      build_apk "$env"
      ;;
    "ios")
      build_ios "$env"
      ;;
    esac
  done
}

select_test_groups() {
  clear_and_print

  items=("dev" "qa" "design")
  # Initialize an array to track selected items
  selected=()

  # Function to display the checkbox list
  display_list() {
    for ((i = 0; i < ${#items[@]}; i++)); do
      echo "$((i + 1)). ${items[$i]}"
    done
  }

  # Main loop for user interaction
  while true; do
    echo "Select Testing Group (comma-separated, 'click enter' to finish):"
    display_list

    read -p "> " input

    # Parse the user input and update the selected array
    IFS=',' read -ra selected_indices <<<"$input"
    for index in "${selected_indices[@]}"; do
      if [[ $index =~ ^[0-9]+$ && $index -ge 1 && $index -le ${#items[@]} ]]; then
        selected+=("${items[$((index - 1))]}")
      else
        clear_and_print
        echo "Invalid input. Please enter valid indices."
        selected=() # Clear selected array
        break
      fi
    done

    if [[ ${#selected[@]} -gt 0 ]]; then
      selected_test_group=$(
        IFS=,
        echo "${selected[*]}"
      )
      break
    fi
  done

  check_env_for_build
}

get_release_notes() {
  clear_and_print
  read -p "Please Enter the release notes: " release_notes
  select_test_groups
}

select_env() {
  clear_and_print
  # Define your list of items
  items=("qa" "integration" "dev" "uat")

  # Initialize an array to track selected items
  selected_environments=()

  # Function to display the checkbox list
  display_list() {
    for ((i = 0; i < ${#items[@]}; i++)); do
      echo "$((i + 1)). ${items[$i]}"
    done
  }

  # Main loop for user interaction
  while true; do
    echo "Select Environments (comma-separated, 'click enter' to finish):"
    display_list

    read -p "> " input

    # Parse the user input and update the selected array
    IFS=',' read -ra selected_indices <<<"$input"
    for index in "${selected_indices[@]}"; do
      if [[ $index =~ ^[0-9]+$ && $index -ge 1 && $index -le ${#items[@]} ]]; then
        selected_environments+=("${items[$((index - 1))]}")
      else
        clear_and_print
        echo "Invalid input. Please enter valid indices."
        selected_environments=() # Clear selected array
        break
      fi
    done
    # Check if selected array is not empty before exiting loop
    if [ ${#selected_environments[@]} -gt 0 ]; then
      break
    fi
  done
  get_release_notes
}

select_all_env() {
  clear_and_print
  read -p "Are you going to distribute to all the lower environments? (y/n)" selected_value
  case "$selected_value" in
  [Yy])
    selected_environments=("qa" "integration" "dev" "uat")
    get_release_notes
    ;;
  [Nn])
    select_env
    ;;
  *)
    echo "Please select Y or n"
    select_all_env
    ;;
  esac
}

select_platform() {
  clear
  echo "Please select a platform (1 for android, 2 for ios, 3 for both)"
  select platform in android ios both; do
    case "$platform" in
    android)
      selected_platform=android
      break
      ;;
    ios)
      selected_platform=ios
      break
      ;;
    both)
      selected_platform=both
      break
      ;;
    *)
      echo "Wrong input. Please select a valid platform (1 for android, 2 for ios, 3 for both)"
      ;;
    esac
  done

  echo "Selected Platform: $selected_platform"
  select_all_env
}

select_platform
