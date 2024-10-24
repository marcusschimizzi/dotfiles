#!/bin/bash

function icon_map() {
  case "$1" in
    "kitty" | "WezTerm")
      icon_result=":terminal:"
      ;;
    "App Store")
      icon_result=":app_store:"
      ;;
    "1Password")
      icon_result=":one_password:"
      ;;
    "Finder")
      icon_result=":finder:"
      ;;
    "Firefox")
      icon_result=":firefox:"
      ;;
    "Spotify")
      icon_result=":spotify:"
      ;;
    "Default")
      icon_result=":default:"
      ;;
    "Safari")
      icon_result=":safari:"
      ;;
    "Arc")
      icon_result=":arc:"
      ;;
    "Messages")
      icon_result=":messages:"
      ;;
    "FaceTime")
      icon_result=":face_time:"
      ;;
    "System Preferences" | "System Settings")
      icon_result=":gear:"
      ;;
    *)
      icon_result=":default:"
      ;;
  esac
}

icon_map "$1"
echo "$icon_result"
