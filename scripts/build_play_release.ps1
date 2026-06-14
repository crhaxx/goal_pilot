# Builds a signed Android App Bundle (.aab) for Google Play Console.
#
# Prerequisites:
#   1. Flutter SDK in PATH
#   2. android/key.properties configured (see android/key.properties.example)
#   3. Upload keystore at android/upload-keystore.jks
#   4. GEMINI_API_KEY environment variable set (or pass -GeminiApiKey)
#
# Usage:
#   $env:GEMINI_API_KEY = "your_key"
#   .\scripts\build_play_release.ps1
#
#   .\scripts\build_play_release.ps1 -GeminiApiKey "your_key"

param(
    [string]$GeminiApiKey = $env:GEMINI_API_KEY
)

$ErrorActionPreference = "Stop"
$Root = Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)
Set-Location $Root

$keyProperties = Join-Path $Root "android\key.properties"
$keystore = Join-Path $Root "android\upload-keystore.jks"

if (-not (Get-Command flutter -ErrorAction SilentlyContinue)) {
    Write-Error "Flutter SDK not found in PATH. Install Flutter and reopen the terminal."
}

if (-not (Test-Path $keyProperties)) {
    Write-Error @"
Missing android/key.properties.

1. Copy android/key.properties.example to android/key.properties
2. Generate a keystore (one-time):
   keytool -genkey -v -keystore android/upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload
3. Fill storePassword, keyPassword, keyAlias, and storeFile in key.properties
"@
}

if (-not (Test-Path $keystore)) {
    Write-Error "Upload keystore not found at android/upload-keystore.jks. See script header for keytool command."
}

if ([string]::IsNullOrWhiteSpace($GeminiApiKey)) {
    Write-Error "Set GEMINI_API_KEY environment variable or pass -GeminiApiKey."
}

if (-not (Test-Path ".env")) {
    Write-Host 'No .env found - copying .env.example for asset bundling (API key comes from --dart-define).'
    Copy-Item ".env.example" ".env"
}

Write-Host "Building release app bundle (app.goalpilot)..." -ForegroundColor Cyan

flutter pub get
flutter build appbundle --release --dart-define=GEMINI_API_KEY=$GeminiApiKey

$bundle = Join-Path $Root "build\app\outputs\bundle\release\app-release.aab"
if (Test-Path $bundle) {
    Write-Host ""
    Write-Host "Success! Upload this file to Google Play Console:" -ForegroundColor Green
    Write-Host $bundle
    Write-Host ""
    Write-Host "Package name: app.goalpilot"
    Write-Host "Version: see pubspec.yaml (versionCode = build number after +)"
} else {
    Write-Error ('Build finished but app bundle was not found at ' + $bundle)
}
