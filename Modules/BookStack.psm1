<#
.Synopsis
   Get BookStack books using the API
.DESCRIPTION
   Retrieves a lost of Bookstack books using a BookStack API call
.EXAMPLE
   Get-BookStackBooks -URL "https://bookstack.local" -Token "1234567890" -Secret "0987654321"
#>
function Get-BookStackBooks
{
    [CmdletBinding()]
    [Alias()]
    [OutputType([String])]
    Param
    (
        # URL BookStack base url
        [Parameter(Mandatory=$true,
                   ValueFromPipelineByPropertyName=$true,
                   Position=0)]
        [String]
        $URL,
        
        # Token BookStack API token
        [Parameter(Mandatory=$true,
                   ValueFromPipelineByPropertyName=$true,
                   Position=1)]
        [String]
        $Token,

        # Secret BookStack API token secret
        [Parameter(Mandatory=$true,
                   ValueFromPipelineByPropertyName=$true,
                   Position=2)]
        [String]
        $Secret
    )

    Begin
    {
        
    }
    Process
    {
        $ApiURI = $URL + "/api/books"
        $ApiHeaders = @{"Authorization" = "Token " + $Token + ':' + $Secret}
        $BookStackBooks = Invoke-RestMethod -Uri $ApiURI -Headers $ApiHeaders
    }
    End
    {
        return $BookStackBooks.data
    }
}

<#
.Synopsis
   Export a BookStack book
.DESCRIPTION
   Exports a BookStack book as HTML to the a specified location in a specified format
.EXAMPLE
   Export-BookStackBook -URL "https://bookstack.local" -Token "1234567890" -Secret "0987654321" -BookID 1 -OutputFormat "HTML" -OutputPath "C:\MyBooks\ThisBook.html"
.EXAMPLE
   Export-BookStackBook -URL "https://bookstack.local" -Token "1234567890" -Secret "0987654321" -BookID 2 -OutputFormat "PDF" -OutputPath "C:\MyBooks\ThisBook.pdf"
#>
function Export-BookStackBook
{
    [CmdletBinding()]
    [Alias()]
    [OutputType([String])]
    Param
    (
        # URL BookStack base url
        [Parameter(Mandatory=$true,
                   ValueFromPipelineByPropertyName=$true,
                   Position=0)]
        [String]
        $URL,
        
        # Token BookStack API token
        [Parameter(Mandatory=$true,
                   ValueFromPipelineByPropertyName=$true,
                   Position=1)]
        [String]
        $Token,

        # Secret BookStack API token secret
        [Parameter(Mandatory=$true,
                   ValueFromPipelineByPropertyName=$true,
                   Position=2)]
        [String]
        $Secret,

        # BookID BookStack BookID to export
        [Parameter(Mandatory=$true,
                   ValueFromPipelineByPropertyName=$true,
                   Position=3)]
        [int]
        $BookID,

        # OutputFormat Export format (PDF or HTML)
        [Parameter(Mandatory=$true,
                   ValueFromPipelineByPropertyName=$true,
                   Position=4)]
        [ValidateSet(“PDF”, "HTML")] 
        [String]
        $OutputFormat,

        # ExportPath Export path (including filename)
        [Parameter(Mandatory=$true,
                   ValueFromPipelineByPropertyName=$true,
                   Position=5)]
        [String]
        $OutputPath
    )

    Begin
    {
        
    }
    Process
    {
        # Build the request
        Switch($OutputFormat.ToLower()) {
            "PDF" {
                $ApiURI = $URL + "/api/books/$BookID/export/pdf"
            }
            default {
                $ApiURI = $URL + "/api/books/$BookID/export/html"
            }
        }

        $ApiHeaders = @{"Authorization" = "Token " + $Token + ':' + $Secret}
        $BookContent = Invoke-RestMethod -Uri $ApiURI -Headers $ApiHeaders
    }
    End
    {
        return ($BookContent | Out-File -FilePath $OutputPath -Force)
    }
}

Export-ModuleMember -Function * 