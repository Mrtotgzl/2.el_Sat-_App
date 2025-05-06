plugins {
    id("com.android.application")
    id("org.jetbrains.kotlin.android") // ✅ Kotlin sürümü güncellendi
    id("dev.flutter.flutter-gradle-plugin")
    id("com.google.gms.google-services")
}

// Versiyon bilgileri gradle.properties dosyasından gelsin
val flutterVersionCode = project.findProperty("flutterVersionCode")?.toString()?.toInt() ?: 1
val flutterVersionName = project.findProperty("flutterVersionName")?.toString() ?: "1.0.0"

android {
    namespace = "com.satisapp.satis_app"
    compileSdk = 35

    defaultConfig {
        applicationId = "com.satisapp.satis_app"
        minSdk = 23
        targetSdk = 34
        versionCode = flutterVersionCode
        versionName = flutterVersionName
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = "11"
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}


    flutter {
    source = "../.."
}

dependencies {
    // Firebase BoM (Bill of Materials) ile sürüm yönetimi
    implementation(platform("com.google.firebase:firebase-bom:33.12.0"))

    // Firebase Analytics
    implementation("com.google.firebase:firebase-analytics")

    // Diğer Firebase servislerini buraya ekleyebilirsin
}
