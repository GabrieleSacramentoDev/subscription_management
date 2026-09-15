import java.io.FileInputStream
import java.util.Properties

plugins {
    id("com.android.application")
    id("kotlin-android")
    // O plugin Gradle do Flutter deve ser aplicado após os plugins do Android e Kotlin
    id("dev.flutter.flutter-gradle-plugin")
    id("com.google.gms.google-services")
}

val keystoreProperties = Properties()
val keystorePropertiesFile = rootProject.file("key.properties")
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
}

val hasReleaseSigning = keystorePropertiesFile.exists() &&
    listOf("keyAlias", "keyPassword", "storePassword", "storeFile").all { key ->
        !keystoreProperties.getProperty(key).isNullOrBlank()
    }

android {
    namespace = "com.gabrielesacramento.subscription_management"
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
        applicationId = "com.gabrielesacramento.subscription_management"

        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    signingConfigs {
        if (hasReleaseSigning) {
            create("release") {
                keyAlias = keystoreProperties.getProperty("keyAlias")
                keyPassword = keystoreProperties.getProperty("keyPassword")
                storePassword = keystoreProperties.getProperty("storePassword")
                storeFile = rootProject.file(
                    keystoreProperties.getProperty("storeFile")!!,
                )
            }
        }
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.findByName("release")
            // Play Console exige AAB assinado com chave de upload (não debug).
        }
        debug {
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

afterEvaluate {
    listOf("bundleRelease", "assembleRelease", "packageRelease").forEach { taskName ->
        tasks.matching { it.name == taskName }.configureEach {
            doFirst {
                check(hasReleaseSigning) {
                    """
                    Assinatura de release não configurada.

                    1. Gere um keystore de upload (validade >= 25 anos):
                       keytool -genkeypair -v -keystore upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload

                    2. Copie android/key.properties.example para android/key.properties

                    3. Registre o certificado de upload no Play Console (Integridade do app).

                    Documentação: https://developer.android.com/studio/publish/app-signing
                    """.trimIndent()
                }
            }
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")
    implementation("androidx.core:core-splashscreen:1.0.1")
}
