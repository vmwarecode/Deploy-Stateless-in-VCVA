############################################################################
#    VMware CopyRight
#    Baoyin created in 2010-12-09
#    This script used to Create the Depot for stateless ESXi.
#############################################################################

Add-PSSnapin Vmware* -ErrorAction SilentlyContinue

# Connect to the vCenter server
Connect-Viserver -Server VCServerIP -user root -password password -WarningAction SilentlyContinue|out-null
#Please update the url for new build
$Depot="http://build-squid.eng.vmware.com/build/storageX/release/bora-xxxxx/publish/CUR-depot/ESXi/index.xml"
Add-ESXSoftwareDepot $Depot
$channel = Get-ESXSoftwareChannel
$ip = Get-ESXImageProfile -SoftwareChannel $channel
#The below steps depends on what kind of image profile you want to use, by default we use the ESX-5.0-xxxx-full to boot stateless ESXi.
$image=$ip|where-object {$_.name -match "full"}
#Create a new rule
$rule=New-DeployRule -name rule1 -item $image -Allhost
#set the rule
Set-DeployRuleSet $rule

#Disconnect from VCVA
Disconnect-VIServer -Server * -Force -Confirm:$false