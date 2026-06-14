plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.zafira.zafira"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        // Requerido por flutter_local_notifications (usa APIs java.time de Java 8+).
        isCoreLibraryDesugaringEnabled = true
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    // ── Flavors (espejo de hey-support) ──────────────────────────────────────
    // El entorno (URL/API) lo elige el entrypoint Dart: lib/main/main_dev.dart
    // y main_prod.dart (vía `envied` + Flavor.setEnvironment). Acá solo se
    // separan applicationId y nombre de app por flavor, para poder instalar
    // DEV y PROD a la vez. Corre con: --flavor dev / --flavor prod.
    flavorDimensions += "flavor-type"

    productFlavors {
        create("dev") {
            dimension = "flavor-type"
            applicationIdSuffix = ".dev"
            versionNameSuffix = "-dev"
            resValue("string", "app_name", "Zafira Dev")
        }

        create("prod") {
            dimension = "flavor-type"
            resValue("string", "app_name", "Zafira")
        }
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.zafira.zafira"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    // Core library desugaring — requerido por flutter_local_notifications.
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")
}
