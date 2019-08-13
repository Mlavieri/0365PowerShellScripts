Connect-MsolService

$tenant = Read-Host 'Tenant Name' #This is your tenant name such as Contoso
$Skupart = Read-Host 'Sku Part Number' #this is the sku you are targeting, Teams and Yammer typically fall under ENTERPRISEPACK but this could be updated to work for other skuks or trials. To view the Skus in your tenant you can run Get-MsoSubscription
$SkuID = $tenant + ":" + $Skupart
$csvContents = @() # Create the empty array that will eventually be the CSV file

$users = (Get-MsolUser -All).UserPrincipalName

foreach ($user in $users){

    $uls = (Get-MsolUser -UserPrincipalName $user).Licenses

    foreach ($ul in $uls){
          
        if ($ul.AccountSkuID -eq $SkuID){
        $plans = $ul.ServiceStatus

            foreach ($plan in $plans){
                if ($plan.ServicePlan.ServiceName -eq "YAMMER_ENTERPRISE"){
                    #$plan.ServicePlan.ServiceName
                    
                    $row = New-Object System.Object # Create an object to append to the array
                    $row | Add-Member -MemberType NoteProperty -Name "User" -Value $user
                    $row | Add-Member -MemberType NoteProperty -Name "PlanName" -Value $plan.ServicePlan.ServiceName
                    $row | Add-Member -MemberType NoteProperty -Name "PlanStatus" -Value $plan.ProvisioningStatus
                    $csvContents += $row # append the new data to the array
                }
                if ($plan.ServicePlan.ServiceName -eq "TEAMS1"){
                    #$plan.ServicePlan.ServiceName
                    
                    $row = New-Object System.Object # Create an object to append to the array
                    $row | Add-Member -MemberType NoteProperty -Name "User" -Value $user
                    $row | Add-Member -MemberType NoteProperty -Name "PlanName" -Value $plan.ServicePlan.ServiceName
                    $row | Add-Member -MemberType NoteProperty -Name "PlanStatus" -Value $plan.ProvisioningStatus
                    $csvContents += $row # append the new data to the array
                }

            }

        }


    }
}

$csvContents | Export-CSV -Path C:\YammerTeamsUsers.csv
