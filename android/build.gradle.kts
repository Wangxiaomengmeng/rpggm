// Top-level build file where you can add configuration options common to all sub-projects/modules.
plugins {
    id "com.android.application" version "7.4.2" apply false
    id "com.android.library" version "7.4.2" apply false
    id "org.jetbrains.kotlin.android" version "1.8.0" apply false
    // 新增：Google Services 插件（Firebase 必需）
    id "com.google.gms.google-services" version "4.4.2" apply false
}

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

// 你的自定义编译目录配置（保留）
val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}

subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}