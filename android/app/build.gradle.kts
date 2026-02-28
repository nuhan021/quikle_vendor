import java.io.File
import java.io.FileInputStream
import java.util.Properties

plugins {
    id("com.android.application")
    // START: FlutterFire Configuration
    id("com.google.gms.google-services")
    // END: FlutterFire Configuration
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

val keystoreProperties = Properties()
val keystorePropertiesFile = rootProject.file("key.properties")
if (keystorePropertiesFile.exists()) {
    FileInputStream(keystorePropertiesFile).use { stream ->
        keystoreProperties.load(stream)
    }
}

fun resolveKeystoreFile(path: String?): File? {
    if (path.isNullOrBlank()) return null

    val fromAbsolute = File(path)
    if (fromAbsolute.isAbsolute && fromAbsolute.exists()) return fromAbsolute

    val fromModule = file(path)
    if (fromModule.exists()) return fromModule

    val fromAndroidRoot = rootProject.file(path)
    if (fromAndroidRoot.exists()) return fromAndroidRoot

    val fromProjectRoot = rootProject.projectDir.parentFile?.resolve(path)
    if (fromProjectRoot?.exists() == true) return fromProjectRoot

    return fromModule
}

android {
    namespace = "com.quikle.quiklevendor"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
        isCoreLibraryDesugaringEnabled = true
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    defaultConfig {
        applicationId = "com.quikle.quiklevendor"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    signingConfigs {
        if (keystorePropertiesFile.exists()) {
            create("release") {
                keyAlias = requireNotNull(keystoreProperties.getProperty("keyAlias")) {
                    "Missing keyAlias in android/key.properties"
                }
                keyPassword = requireNotNull(keystoreProperties.getProperty("keyPassword")) {
                    "Missing keyPassword in android/key.properties"
                }
                storeFile = resolveKeystoreFile(keystoreProperties.getProperty("storeFile"))
                storePassword = requireNotNull(keystoreProperties.getProperty("storePassword")) {
                    "Missing storePassword in android/key.properties"
                }
            }
        }
    }

    buildTypes {
        release {
            if (keystorePropertiesFile.exists()) {
                signingConfig = signingConfigs.getByName("release")
            } else {
                signingConfig = signingConfigs.getByName("debug")
            }
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    add("coreLibraryDesugaring", "com.android.tools:desugar_jdk_libs:2.1.4")
}
