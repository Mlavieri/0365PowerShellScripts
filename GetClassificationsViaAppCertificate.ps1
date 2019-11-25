Param(

   [Parameter(Mandatory=$true)]
   [string]$Tenant,

   [Parameter(Mandatory=$true)]
   [string]$Thumbprint,
   
   [Parameter(Mandatory=$true)]
   [string]$Client,

   #https://tenant.sharepoint.com/site/
   [Parameter(Mandatory=$true)]
   [string]$ListSiteURL,

   [Parameter(Mandatory=$true)]
   [string]$ListName
)

$Domain = $Tenant+".onmicrosoft.com"
$AdminURL = "https://"+$Tenant+"-admin.sharepoint.com"


#Connect Using Certificate Thumbprint

Connect-PnPOnline `
            -Thumbprint $Thumbprint `
            -Tenant $Domain `
            -ClientId $Client `
            -Url $AdminURL

$sites = Get-PnPTenantSite

foreach ($site in $sites){

    Connect-PnPOnline `
        -Thumbprint $Thumbprint `
        -Tenant $Domain `
        -ClientId $Client `
        -Url $site.Url

    $sp = Get-PnPSite
    $classificationValue = Get-PnPProperty -ClientObject $sp -Property Classification

    if ($classificationValue -eq "Sensitive"){
             Disconnect-PnPOnline
             Connect-PnPOnline `
            -Thumbprint $Thumbprint `
            -Tenant $Domain `
            -ClientId $Client `
            -Url $ListSiteUrl
        $url = Get-PnPProperty -ClientObject $sp -Property Url
        $Owner = Get-PnPProperty -ClientObject $sp -Property Owner
        Add-PnPListItem -List $ListName -Values @{"Title" = $url; "Classification" = $classificationValue; "Owner" = $Owner.Email; "Url" = $url}
    }
    $classificationValue = ""
}
