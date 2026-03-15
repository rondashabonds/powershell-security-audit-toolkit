# PowerShell Security Audit Toolkit
# Author: Gabby Bonds
# Description: Collects basic Windows security information and generates an HTML report

$timestamp = Get-Date -Format "yyyy-MM-dd_HH-mm-ss"
$reportPath = ".\security-audit-report-$timestamp.html"

Write-Host "Starting security audit..." -ForegroundColor Cyan

# 1. Firewall Status
Write-Host "Checking firewall profiles..." -ForegroundColor Yellow
$firewallStatus = Get-NetFirewallProfile | Select-Object Name, Enabled, DefaultInboundAction, DefaultOutboundAction

# 2. Windows Defender Status
Write-Host "Checking Microsoft Defender..." -ForegroundColor Yellow
try {
    $defenderStatus = Get-MpComputerStatus | Select-Object `
        AMServiceEnabled,
        AntivirusEnabled,
        AntispywareEnabled,
        RealTimeProtectionEnabled,
        IoavProtectionEnabled,
        NISEnabled
}
catch {
    $defenderStatus = [PSCustomObject]@{
        AMServiceEnabled          = "Unavailable"
        AntivirusEnabled          = "Unavailable"
        AntispywareEnabled        = "Unavailable"
        RealTimeProtectionEnabled = "Unavailable"
        IoavProtectionEnabled     = "Unavailable"
        NISEnabled                = "Unavailable"
    }
}

# 3. Failed Login Attempts (Event ID 4625)
Write-Host "Checking failed login attempts..." -ForegroundColor Yellow
try {
    $failedLogins = Get-WinEvent -FilterHashtable @{
        LogName = 'Security'
        Id      = 4625
        StartTime = (Get-Date).AddDays(-7)
    } -ErrorAction Stop | Select-Object -First 10 TimeCreated, Id, ProviderName, Message
}
catch {
    $failedLogins = @(
        [PSCustomObject]@{
            TimeCreated  = "Access Denied / Run PowerShell as Administrator"
            Id           = ""
            ProviderName = ""
            Message      = "Could not read Security event logs."
        }
    )
}

# 4. Open Listening Ports
Write-Host "Checking listening ports..." -ForegroundColor Yellow
try {
    $listeningPorts = Get-NetTCPConnection -State Listen | 
        Select-Object LocalAddress, LocalPort, RemoteAddress, RemotePort, State |
        Sort-Object LocalPort
}
catch {
    $listeningPorts = @(
        [PSCustomObject]@{
            LocalAddress  = "Unavailable"
            LocalPort     = ""
            RemoteAddress = ""
            RemotePort    = ""
            State         = ""
        }
    )
}

# 5. Security Services Status
Write-Host "Checking important services..." -ForegroundColor Yellow
$serviceNames = @("WinDefend","mpssvc","EventLog")
$services = Get-Service | Where-Object { $serviceNames -contains $_.Name } |
    Select-Object Name, DisplayName, Status, StartType

# HTML Styling
$style = @"
<style>
body {
    font-family: Arial, sans-serif;
    margin: 20px;
    background-color: #f7f9fc;
    color: #222;
}
h1, h2 {
    color: #0b3d91;
}
table {
    border-collapse: collapse;
    width: 100%;
    margin-bottom: 25px;
    background: white;
}
th, td {
    border: 1px solid #dcdcdc;
    padding: 8px;
}
th {
    background-color: #eaf2ff;
}
.section {
    margin-bottom: 30px;
}
</style>
"@

# HTML Header
$header = @"
<html>
<head>
<title>Security Audit Report</title>
$style
</head>
<body>
<h1>PowerShell Security Audit Report</h1>
<p><strong>Generated:</strong> $(Get-Date)</p>
"@

# Convert Data to HTML Tables
$firewallHtml = "<div class='section'><h2>Firewall Status</h2>" + ($firewallStatus | ConvertTo-Html -Fragment) + "</div>"
$defenderHtml = "<div class='section'><h2>Microsoft Defender Status</h2>" + ($defenderStatus | ConvertTo-Html -Fragment) + "</div>"
$failedLoginsHtml = "<div class='section'><h2>Recent Failed Login Attempts</h2>" + ($failedLogins | ConvertTo-Html -Fragment) + "</div>"
$listeningPortsHtml = "<div class='section'><h2>Listening TCP Ports</h2>" + ($listeningPorts | ConvertTo-Html -Fragment) + "</div>"
$servicesHtml = "<div class='section'><h2>Security Services</h2>" + ($services | ConvertTo-Html -Fragment) + "</div>"

# HTML Footer
$footer = "</body></html>"

# Combine Everything
$fullReport = $header + $firewallHtml + $defenderHtml + $failedLoginsHtml + $listeningPortsHtml + $servicesHtml + $footer

# Export Report
$fullReport | Out-File -FilePath $reportPath -Encoding UTF8

Write-Host "Audit complete." -ForegroundColor Green
Write-Host "Report saved to: $reportPath" -ForegroundColor Green