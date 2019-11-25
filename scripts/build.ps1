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

(Get-Content CorshamScience.CodeStyle.CSharp.CodeOnly.template.props) -replace "#.#.#","$version" | Set-Content CorshamScience.CodeStyle.CSharp.CodeOnly.props
&$nuget pack CorshamScience.CodeStyle.CSharp.CodeOnly.nuspec -Version $version -OutputDirectory dist