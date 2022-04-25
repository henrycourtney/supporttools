#Created 24 APR 2022 by Henry Courtney
#used to time the loading of a website. Log to a csv file. 

# Set Domain
$domain = Read-Host -Prompt 'Input domain to lookup' 
# Set DNS Server
$dnsserver = Read-Host -Prompt 'enter 1 DNS Server IP'
# Set number of loops
$count = Read-Host -Prompt 'Input number of loops' 

Write-Host "domain to check '$domain'"
Write-Host "DNS Server IP '$dnsserver'"
Write-Host "Will cycle for '$count' with .5 second sleep inbetween"
pause 


#Variables
$watch = New-Object System.Diagnostics.Stopwatch
$date = Get-Date -Format "dd_MMM_yyy"
$time = Get-date -Format "hh_mm_ss"

$file = $domain + '_' + $date + '_' + $time 
$file = $file -replace '[\W]', '_' 
$file = $file + ".csv"

#Set domain Prefix. Chane to HTTP or HTTPS depending on the site
#set headers
Write-Output "domain, dnsserver, dnslookup, runtime, date, time" | out-file -Encoding Ascii -FilePath $file -append

#loop
1..$count | ForEach-object { 
    #get Time and date of loop
    $date = Get-Date -Format "ddMMMyyy"
    $time = Get-date -Format "hh:mm:ss"

    #start Timer
    $watch.Start() #put this at start of the loop

    # Get Website
    $dnslookup = (Resolve-DnsName -name $domain -server $dnsserver -type A).IPADDRESS | Select-Object -First 1 


    # get time elapsed as Variable
    $runtime = $watch.Elapsed.TotalSeconds 

    #Display to console
    write-host $domain $dnsserver $dnslookup $runtime  $date  $time

    #write to file
    $domain, $dnsserver, $dnslookup, $runtime, $date, $time -join ","  | out-file -Encoding Ascii -FilePath $file -append

    #Reset timer
    $watch.reset()
    $dnslookup = $null
    Start-Sleep 1

}
