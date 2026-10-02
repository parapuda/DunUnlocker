#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "${BASH_SOURCE[0]}")/.."
[[ $(uname -s) == Linux && $(uname -m) == x86_64 ]] || {
  echo 'This bootstrap supports Linux x86_64. See docs/development.md for other hosts.' >&2
  exit 1
}
for command in java curl unzip sha256sum; do
  command -v "$command" >/dev/null || { echo "Missing command: $command" >&2; exit 1; }
done
grep -qx 'compileSdk = "37"' gradle/libs.versions.toml || {
  echo 'compileSdk changed: update the SDK and matching hidden API jar together.' >&2
  exit 1
}

sdk=$PWD/.local/android-sdk
cache=$PWD/.local/downloads
mkdir -p "$cache" "$sdk"

fetch() {
  local url=$1 destination=$2 checksum=$3
  if [[ -f $destination ]] && printf '%s  %s\n' "$checksum" "$destination" | sha256sum -c --status; then
    return
  fi
  curl -fL --retry 3 "$url" -o "$destination.part"
  printf '%s  %s\n' "$checksum" "$destination.part" | sha256sum -c -
  mv "$destination.part" "$destination"
}

if [[ ! -x $sdk/cmdline-tools/latest/bin/android ]]; then
  fetch https://dl.google.com/android/repository/commandlinetools-linux-16111833_latest.zip \
    "$cache/commandlinetools.zip" \
    0877a1d048fe4a24efe2eff536ca4223f7adeb58648bb81909d33c446918cfa8
  mkdir -p "$sdk/cmdline-tools"
  unzip -q "$cache/commandlinetools.zip" -d "$sdk/cmdline-tools"
  mv "$sdk/cmdline-tools/cmdline-tools" "$sdk/cmdline-tools/latest"
fi

android=$sdk/cmdline-tools/latest/bin/android
for package in 'platforms;android-37.0' 'build-tools;36.0.0' platform-tools; do
  "$android" --no-metrics --sdk="$sdk" sdk install "$package"
done

# Framework headers from android-17.0.0_r1, pinned to the source repository commit.
fetch https://raw.githubusercontent.com/Reginer/aosp-android-jar/262f6ae931160011572a5adfe4ec6302585e8f60/android-37/android-jdk21.jar \
  "$cache/android-37-hidden.jar" \
  694b291a046b4ba1738e9df61577ec8cfddf250a7bbe9867a72ff19e161ea692
platform=$sdk/platforms/android-37.0
[[ -f $platform/android.jar.stock ]] || cp "$platform/android.jar" "$platform/android.jar.stock"
install -m 644 "$cache/android-37-hidden.jar" "$platform/android.jar"
printf 'sdk.dir=%s\n' "$sdk" > local.properties
echo "Ready: $sdk (hidden API jar installed). Run: mise run check"
