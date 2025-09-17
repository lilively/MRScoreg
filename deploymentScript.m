projectRoot = "C:\Users\lilif\OneDrive\Desktop\mrscoreg";

% Create target build options object, set build properties and build.
buildOpts = compiler.build.StandaloneApplicationOptions(fullfile(projectRoot, "coregistration.mlapp"));
buildOpts.AdditionalFiles = [fullfile(projectRoot, "SPM12deps"), fullfile(projectRoot, "SPM12deps", "@file_array"), fullfile(projectRoot, "SPM12deps", "@file_array", "private"), fullfile(projectRoot, "SPM12deps", "@nifti"), fullfile(projectRoot, "SPM12deps", "src")];
buildOpts.AutoDetectDataFiles = true;
buildOpts.OutputDir = fullfile(projectRoot, "MRScoreg", "output", "build");
buildOpts.ObfuscateArchive = false;
buildOpts.Verbose = true;
buildOpts.EmbedArchive = true;
buildOpts.ExecutableIcon = fullfile(projectRoot, "MRScoregIcon5.png");
buildOpts.ExecutableName = "MRScoreg";
buildOpts.ExecutableSplashScreen = fullfile(projectRoot, "Coreglogo7_Splash.png");
buildOpts.ExecutableVersion = "1.0";
buildOpts.TreatInputsAsNumeric = false;
buildResult = compiler.build.standaloneApplication(buildOpts);


% Create package options object, set package properties and package.
packageOpts = compiler.package.InstallerOptions(buildResult);
packageOpts.ApplicationName = "MRScoreg";
packageOpts.AuthorName = "Lili Fanni Toth";
packageOpts.OutputDir = fullfile(projectRoot, "MRScoreg", "output", "package");
packageOpts.Verbose = true;
packageOpts.Version = "1.0";
compiler.package.installer(buildResult, "Options", packageOpts);