allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

// Redirected off the D: drive (which has no free space left) onto C:, which
// does. mergeDebugNativeLibs and friends need real headroom for temp/merge
// output that the project's own drive doesn't have.
val newBuildDir: Directory =
    rootProject.layout.projectDirectory
        .dir("C:/FlutterBuilds/infortapp/build")
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
