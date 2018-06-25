$apikey = ''

if ($args[0]) { $apikey=$args[0] }
else { 
	$host.ui.WriteLine('Please specify myget api key as parameter to script!')
	$host.ui.WriteLine('.\publish.ps1 <apikey>')
	exit 1
}

$nuget = '.nuget\nuget.exe'
If (-not (Test-Path $nuget)) {
	If (-not (Test-Path '.nuget')) {
		mkdir '.nuget'
	}

	$nugetSource = 'https://dist.nuget.org/win-x86-commandline/latest/nuget.exe'
	Invoke-WebRequest $nugetSource -OutFile $nuget
	If (-not $?) {
		$host.ui.WriteErrorLine('Unable to download NuGet executable, aborting!')
		exit $LASTEXITCODE
	}
}

$version = &gitversion.exe /showvariable NuGetVersionV2

.\build.ps1 $version

&$nuget push .\CR.CodeStyle.CSharp.Full.$version.nupkg $apikey -Source https://www.myget.org/F/cognisant-libs/api/v2/package