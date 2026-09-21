import java.util.Properties
import java.io.FileInputStream

plugins {
    id("com.android.application")
    id("com.google.gms.google-services")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

/* ================================
   KEYSTORE (RELEASE SIGNING)
   ================================ */
val keystoreProperties = Properties()
val keystorePropertiesFile = rootProject.file("key.properties")

if (keystorePropertiesFile.exists()) {
    keystorePropertiesFile.inputStream().use { input ->
        keystoreProperties.load(input)
    }
}

android {
    namespace = "com.softel.b2bapp"   // ✅ FIXED (IMPORTANT)
    compileSdk = flutter.compileSdkVersion
    ndkVersion = "28.2.13676358"

    /* ================================
       JAVA / KOTLIN CONFIG
       ================================ */
    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

   kotlin {
    compilerOptions {
        jvmTarget.set(org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_11)
    }
}

    /* ================================
       DEFAULT CONFIG
       ================================ */
    defaultConfig {
        applicationId = "com.softel.b2bapp"  // ✅ FIXED
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName

        // Google Sign-In / Firebase OAuth
        manifestPlaceholders["REVERSED_CLIENT_ID"] =
            "com.googleusercontent.apps.198997354824-m74pe9btumaqvi5lec9dqiglg6tijus7"
    }

    /* ================================
       SIGNING CONFIG
       ================================ */
    signingConfigs {
        create("release") {
            keyAlias = keystoreProperties.getProperty("keyAlias")
            keyPassword = keystoreProperties.getProperty("keyPassword")

            val storeFilePath = keystoreProperties.getProperty("storeFile")
            storeFile = storeFilePath?.let { file(it) }

            storePassword = keystoreProperties.getProperty("storePassword")
        }
    }

    /* ================================
       BUILD TYPES
       ================================ */
    buildTypes {
        getByName("debug") {
            signingConfig = signingConfigs.getByName("debug")
        }

        getByName("release") {
            signingConfig = signingConfigs.getByName("release")

            isMinifyEnabled = false
            isShrinkResources = false

            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
        }
    }
}

/* ================================
   FLUTTER SOURCE
   ================================ */
flutter {
    source = "../.."
}