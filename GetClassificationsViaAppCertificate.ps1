#Connect Using Certificate Thumbprint
Connect-PnPOnline `
            -Thumbprint '<>' `
            -Tenant <>.onmicrosoft.com `
            -ClientId <> `
            -Url https://<>-admin.sharepoint.com
            
#Get All Sites
$sites = Get-PnPTenantSite

#Lopp through each site
foreach ($site in $sites){

#Connect to site
    Connect-PnPOnline `
        -Thumbprint '<>' `
        -Tenant <>.onmicrosoft.com `
        -ClientId <> `
        -Url $site.Url

#Check Classification
    $sp = Get-PnPSite
    $classificationValue = Get-PnPProperty -ClientObject $sp -Property Classification

#If Classification zmeets Value
    if ($classificationValue -eq "Sensitive"){
        Connect-PnPOnline `
            -Thumbprint '<>' `
            -Tenant <>.onmicrosoft.com `
            -ClientId <> `
            -Url https://<>.sharepoint.com
        $url = Get-PnPProperty -ClientObject $sp -Property Url
       $Owner = Get-PnPProperty -ClientObject $sp -Property Owner
       #Write output to SP List at Root SC
       Add-PnPListItem -List "SPSites" -Values @{"Title" = $url; "Classification" = $classificationValue; "Owner" = $Owner.Email; "Url" = $url}
    }
    $classificationValue = ""
}
