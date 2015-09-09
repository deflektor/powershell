[CmdletBinding()]
Param (
  [string]$workpackage = $(throw "-workpackage is required.")
)

Add-Type -Path 'Microsoft.SharePoint.Client.dll'
Add-Type -Path 'Microsoft.SharePoint.Client.Runtime.dll'

$mypass = Read-Host 'What is your password?' -AsSecureString
$mypass2 =  [System.Runtime.InteropServices.Marshal]::PtrToStringAuto([System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($mypass))

$credentials = New-Object System.Net.NetworkCredential($env:username, $mypass2 ,$env:userdomain)
$webUrl = 'https://p02.at.three.com/sites/changeportal/' + $workpackage   
#    W110001'


$ctx = New-Object Microsoft.SharePoint.Client.ClientContext($webUrl)
$ctx.Credentials = $credentials            

$camlQuery = New-Object Microsoft.SharePoint.Client.CamlQuery
$camlQuery.ViewXml = "<View>
<Query>
   <Where> 
     <Eq>   
       <FieldRef Name='Title' /> 
       <Value Type='Text'>Test Task 2</Value>
     </Eq>
   </Where>
 </Query>
 <RowLimit>1</RowLimit>
</View>"

$taskList = $ctx.Web.Lists.GetByTitle("Tasks")
$items = $taskList.GetItems($camlQuery);
$ctx.Load($taskList)
$ctx.Load($items)

$ctx.ExecuteQuery()   

# here is the call after receiving data from the server
$taskList.Title
foreach($item in $items)
{
    Write-Host "Title: " $item["Title"]
}

# update first item
$taskItem = $items[0]

#$taskItem["Body"] = $taskItem["Body"] + "_just a CSOM test"
Write-Host "Actual Effort " $taskItem["t_actualeffort"]
Write-Host "Type of field " $taskItem["t_actualeffort"].GetType().fullname
$mystr = new-object System.Text.Stringbuilder
$mystr = "10"
$taskItem["t_actualeffort"] = $mystr
$taskItem.Update()

$ctx.ExecuteQuery()   
