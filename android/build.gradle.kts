import org.gradle.api.tasks.Delete
import org.gradle.api.file.Directory

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

// Derleme dizinini dışarı taşıma (opsiyonel)
val newBuildDir: Directory = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}

// Uygulama alt projesine bağımlılık (gerekli değilse kaldırılabilir)
subprojects {
    project.evaluationDependsOn(":app")
}

// Clean görevi
tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}

