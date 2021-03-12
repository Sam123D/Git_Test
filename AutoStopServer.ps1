param ( 
    [object]$WebhookData
)
 
if ($WebhookData -ne $null) {  
 
    $WebhookBody = (ConvertFrom-Json -InputObject $WebhookData.RequestBody)
    $Context = [object]$Body.context
    $AlertContext = [object] ($WebhookBody.data).context
    $SubId = $AlertContext.subscriptionId
    $ResourceGroupName = $AlertContext.resourceGroupName
    $ResourceType = $AlertContext.resourceType
    $ResourceName = $AlertContext.resourceName 
  
    $ConnectionName = "AzureRunAsConnection"
    $Connection = Get-AutomationConnection -Name $ConnectionName
 
    Add-AzAccount -ServicePrincipal -Tenant $Connection.TenantID -ApplicationId $Connection.ApplicationID -CertificateThumbprint $Connection.CertificateThumbprint | Write-Verbose
 
 Set-AzContext -SubscriptionId $SubId -ErrorAction Stop | Write-Verbose
 
 Stop-AzVM -Name $ResourceName -ResourceGroupName $ResourceGroupName -Force
     
}