#Separate Hub Site Structured sites from non-structured sites
$structured = @()
$unstructured = @()

#Get All sites in Tenant
Get-SPOSite | ForEach {

	#Get the URL of each site
    $siteUrl =  $_.Url
	
	try{
		#Check if the site is a hub site or associated with one (expection, if not)
		$hubsite = Get-SPOHubSite $siteUrl
		
		#Check if the HubSite has already been added
		if($structured.SiteUrl -ne $hubsite.SiteUrl){
		
			#if not, add the hubsite
			[System.Collections.ArrayList]$arrList=@()
			$hubsite | Add-Member -MemberType NoteProperty -Name AssocSites -value $arrlist
			$structured += $hubsite
			
		}
		
		#Don't add the hubsite as an associated site
		if($_.Url -ne $hubsite.SiteUrl){
			($structured | Where-Object { $_.SiteUrl -eq $hubsite.SiteUrl }).AssocSites += $_
		}
		
	}
	
	#If not a hub site 
	catch{
		$unstructured += $siteUrl
	}
}

#Output in text file
$output = ""
$structured | ForEach {
	$output += $_.Title + " - " + $_.SiteUrl + $("" | Out-String)
	$_.AssocSites | ForEach {
		$output += "    " + $_.TItle + " - " + $_.Url + $("" | Out-String)
	}
	$output += $("" | Out-String)
}
 
 $output | Out-File C:\Users\JensNannerup\Desktop\Privat\MVP\Customizing\SiteScript\file2.txt
 
