# A simple script to export the content of all books in a BookStack wiki to a specified folder

# Import the module
Import-Module "$PSScriptRoot/Modules/BookStack.psm1" -Force

# Variables
$OutputFolder = "C:\mywikidumpfolder"
$APIToken = ""
$APISecret = ""
$WikiURL = "https://my.wiki.url"
$ExportFormat = "html"
$CleanFolder = $false # CAREFUL!

# Get the books
$BookStackBooks = Get-BookStackBooks -URL $WikiURL -Token $APIToken -Secret $APISecret
Write-Progress -PercentComplete 0 -Activity "Preparing" -Status "Starting the export $($BookStackBooks.Count) books to download.)"

# Clean the directory?
If($CleanFolder) 
{ 
    Write-Progress -PercentComplete 0 -Activity "Preparing" -Status "Cleaning folders"
    Get-ChildItem -Path $OutputFolder | Remove-Item -Force 
}

# Export each book
$ExportProgress = 0
foreach($BookStackBook in $BookStackBooks) {
    $ExportProgress++
    Write-Progress -PercentComplete ((100/$BookStackBooks.Count) * $ExportProgress) -Activity "Exporting books" -Status ("Exporting " + $BookStackBook.name)
    Export-BookStackBook -URL $WikiURL -Token $APIToken -Secret $APISecret -BookID $BookStackBook.id -OutputFormat $ExportFormat -OutputPath "$OutputFolder\$($BookStackBook.slug).$ExportFormat"
}