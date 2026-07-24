plugins {
    id("com.android.application")
    id("kotlin-android")
    // O plugin Gradle do Flutter deve ser aplicado após os plugins do Android e Kotlin
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.subscription_management"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        // Obrigatório para o flutter_local_notifications (recursos Java 8+)
        isCoreLibraryDesugaringEnabled = true

        sourceCompatibility = JavaVersion.VERSION_1_8
        targetCompatibility = JavaVersion.VERSION_1_8
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_1_8.toString()
    }

    defaultConfig {
        applicationId = "com.example.subscription_management"
        
        // Defina minSdk 21 ou superior para suporte total a notificações locais
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            // Configuração de assinatura para debug/release
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    // Dependência necessária para o Desugaring funcionar no Gradle
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")
}
