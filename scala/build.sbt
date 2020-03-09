resolvers += Resolver.sonatypeRepo("releases")
addCompilerPlugin(
  "org.typelevel" %% "kind-projector" % "0.11.0" cross CrossVersion.full
)
addCompilerPlugin("com.olegpy" %% "better-monadic-for" % "0.3.1")

val scalaVersionValue = "2.13.1"

lazy val commonSettings = Seq(
  organization := "net.kgtkr",
  scalaVersion := scalaVersionValue,
  scalacOptions ++= Seq(
    "-language:higherKinds",
    "-Ymacro-annotations"
  ),
  scalacOptions in (Compile, compile) ++= Seq(
    "-Ywarn-unused",
    "-Ywarn-macros:after"
  )
)

val zioVersion = "1.0.0-RC14"
val monocleVersion = "2.0.0"

lazy val root = (project in file("."))
  .settings(commonSettings: _*)
  .settings(
    name := "calc",
    version := "0.1",
    libraryDependencies ++= Seq(
      "org.typelevel" %% "cats-core" % "2.0.0",
      "org.typelevel" %% "cats-mtl-core" % "0.7.0",
      "org.typelevel" %% "kittens" % "2.0.0",
      "org.typelevel" %% "simulacrum" % "1.0.0"
    )
  )
