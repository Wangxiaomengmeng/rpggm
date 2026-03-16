plugins {
    id "com.android.application"
    id "kotlin-android"
    id "dev.flutter.flutter-gradle-plugin"
    // 新增：应用 Google Services 插件（Firebase 必需）
    id "com.google.gms.google-services"
}

android {
    namespace "com.example.rpg_game" // 替换为你的包名
    compileSdkVersion 34

    defaultConfig {
        applicationId "com.example.rpg_game" // 必须和 Firebase 控制台填写的包名一致
        minSdkVersion 21 // Firebase 要求 ≥19，建议 21
        targetSdkVersion 34
        versionCode flutterVersionCode.toInteger()
        versionName flutterVersionName
    }

    buildTypes {
        release {
            signingConfig signingConfigs.debug // 测试用，正式打包需配置签名
            minifyEnabled false
        }
    }

    compileOptions {
        sourceCompatibility JavaVersion.VERSION_1_8
        targetCompatibility JavaVersion.VERSION_1_8
    }

    kotlinOptions {
        jvmTarget = "1.8"
    }
}

flutter {
    source "../.."
}

dependencies {
    implementation "org.jetbrains.kotlin:kotlin-stdlib-jdk7:1.8.0"
}