$version = "0.0.0"

if ($args[0]) { $version=$args[0] }

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

Get-Content CR.CodeStyle.CSharp.Full.template.props | ForEach-Object{$_ -replace "#.#.#","$version"} > CR.CodeStyle.CSharp.Full.props
&$nuget pack CR.CodeStyle.CSharp.Full.nuspec -Version $version -OutputDirectory dist