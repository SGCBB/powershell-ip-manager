#
# POWERSHELL GUI - IP MANAGER
# Created by Brandon Bundy
#

if ([System.IO.Path]::GetExtension($PSCommandPath) -eq '.ps1') {
	if ($PSCommandPath -eq $null) { function GetPSCommandPath() { return $MyInvocation.PSCommandPath; } $PSCommandPath = GetPSCommandPath }
	$psScriptPath = Split-Path -Path $PSCommandPath -Parent
	$psScriptName = Split-Path -Path $PSCommandPath -Leaf
	#$psScriptFullPath = $psScriptPath.Replace($MyInvocation.MyCommand.Name,'') + "\" + $MyInvocation.MyCommand.Name
	$psScriptFullPath = $psScriptPath + "\" + $psScriptName
	# CONFIRMATION OF VARIABLES
	#Write-Host "$($psScriptFullPath)`n$($psScriptPath)`n$($psScriptName)"
} else {
	# RETURNS THE FULL PATH TO EXE FILENAME
	$psScriptFullPath = [System.Diagnostics.Process]::GetCurrentProcess().MainModule.FileName
	$psScriptPath = Split-Path -Path $psScriptFullPath -Parent
	$psScriptName = Split-Path -Path $psScriptFullPath -Leaf
	# CONFIRMATION OF VARIABLES
	#[void][System.Windows.Forms.MessageBox]::Show("$($psScriptFullPath)`n`n$($psScriptPath)`n`n$($psScriptName)","test")
}

# CHECK IF RUNNING AS ADMIN AND IF NOT THEN RE-LAUNCH AS ADMIN
$principal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
if($principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    
    Add-Type -AssemblyName System.Windows.Forms
    Add-Type -AssemblyName System.Drawing
    
    [System.Windows.Forms.Application]::EnableVisualStyles()
    
    # CONFIG FILE
	if ([System.IO.Path]::GetExtension($PSCommandPath) -eq '.ps1') {
		#$global:configFile = $PSScriptRoot + "\" + "$($MyInvocation.MyCommand.Name.Replace('.ps1','')).ini"
		#$global:configFile = $psScriptPath.Replace($MyInvocation.MyCommand.Name,'') + "\" + "$($MyInvocation.MyCommand.Name.Replace('.ps1','')).ini"
		$global:configFile = $psScriptFullPath.Replace('.ps1','') + ".ini"
	} else {
		$global:configFile = $psScriptFullPath.Replace('.exe','') + ".ini"
	}
	
    # ICON
    $base64Icon = "AAABAAEAEBAAAAEAIABoBAAAFgAAACgAAAAQAAAAIAAAAAEAIAAAAAAAAAQAABMLAAATCwAAAAAAAAAAAAAAAAAAAAAAABO3/QATt/0JE7f9BRO3/SETt/1uE7f9AxO3/QITt/1pE7f9JRO3/QQTt/0KE7f9AAAAAAAAAAAAAAAAAAAAAAATt/0AE7f9OhO3/VATt/0IE7f9mBO3/S0Tt/0mE7f9mhO3/QsTt/1ME7f9PhO3/QAAAAAAAAAAAAAAAAAAAAAAE7f9ABO3/SETt/2gE7f9FRO3/XUTt/2pE7f9pRO3/X0Tt/0SE7f9nxO3/SUTt/0AAAAAAAAAAAATt/0JE7f9PRO3/SQTt/0HE7f9oRO3/WoTt/0kE7f9hRO3/YYTt/0pE7f9ZBO3/aYTt/0IE7f9IhO3/T4Tt/0LE7f9BRO3/U0Tt/2gE7f9pRO3/cUTt/1LE7f9ABO3/QATt/0AE7f9ABO3/UUTt/3DE7f9phO3/aETt/1QE7f9BhO3/SITt/0JE7f9EhO3/WYTt/1KE7f9ABO3/QAAAAAAAAAAABO3/QATt/0AE7f9RhO3/WgTt/0TE7f9CBO3/SMTt/1pE7f9mRO3/XkTt/0nE7f9ABO3/QAAAAAAAAAAAAAAAAAAAAAAE7f9ABO3/QATt/0lE7f9dxO3/ZkTt/1tE7f9AxO3/ScTt/2mE7f9iBO3/QATt/0AAAAAAAAAAAAAAAAAAAAAABO3/QATt/0AE7f9gBO3/awTt/0pE7f9AxO3/QMTt/0lE7f9phO3/YgTt/0AE7f9AAAAAAAAAAAAAAAAAAAAAAATt/0AE7f9ABO3/YETt/2rE7f9KBO3/QMTt/1qE7f9mxO3/XwTt/0oE7f9ABO3/QAAAAAAAAAAAAAAAAAAAAAAE7f9ABO3/QATt/0mE7f9ehO3/ZsTt/1uE7f9JRO3/QoTt/0RE7f9ZBO3/UcTt/0AE7f9AAAAAAAAAAAAE7f9ABO3/QATt/1DE7f9ZhO3/RMTt/0JE7f9JRO3/QUTt/1LE7f9nxO3/acTt/3EE7f9RxO3/QATt/0AE7f9ABO3/QATt/1CE7f9wxO3/acTt/2gE7f9ThO3/QYTt/0JE7f9PhO3/SUTt/0IE7f9oxO3/WkTt/0jE7f9ghO3/YMTt/0nE7f9YxO3/agTt/0JE7f9IxO3/T8Tt/0LAAAAAAAAAAATt/0AE7f9IRO3/aETt/0VE7f9dBO3/asTt/2mE7f9fBO3/RITt/2gE7f9JhO3/QAAAAAAAAAAAAAAAAAAAAAAE7f9ABO3/TsTt/1SE7f9CBO3/ZgTt/0tE7f9JxO3/ZoTt/0LE7f9ThO3/UATt/0AAAAAAAAAAAAAAAAAAAAAABO3/QATt/0KE7f9BhO3/SETt/1vE7f9BBO3/QITt/1qE7f9JRO3/QUTt/0LE7f9AAAAAAAAAAAA4AcAAOAHAADgBwAAAAAAAAPAAAAD4AAAD/AAAA/wAAAP8AAAD/AAAAPgAAADwAAAAAAAAOAHAADgBwAA4AcAAA=="
    $imageStream = [System.IO.MemoryStream]::new([System.Convert]::FromBase64String($base64Icon))
    $icon = [System.Drawing.Icon]::new($imageStream)
    
    # FORM
    $form = New-Object System.Windows.Forms.Form
    $form.Text = "IP Address Manager"
    $form.Size = New-Object System.Drawing.Size(575, 700)
    $form.StartPosition = "CenterScreen"
    $form.FormBorderStyle = 'FixedSingle' # Options: FixedSingle, Fixed3D, FixedDialog, FixedToolWindow
    $form.Topmost = $true
    $form.Icon = $icon
    $form.Font = New-Object System.Drawing.Font("Arial", 8)
    
    # MENU
    $menuStrip = New-Object System.Windows.Forms.MenuStrip
    $menuStrip.Font = New-Object System.Drawing.Font("Arial", 10)
    $form.Controls.Add($menuStrip)
    # MENU - FILE
    $fileMenu = new-object System.Windows.Forms.ToolStripMenuItem
    $fileMenu.Name = "fileToolStripMenuItem"
    $fileMenu.Size = New-Object System.Drawing.Size(35, 20)
    $fileMenu.Text = "&File"
    # MENU - HELP
    $helpMenu = new-object System.Windows.Forms.ToolStripMenuItem
    $helpMenu.Name = "fileToolStripMenuItem"
    $helpMenu.Size = New-Object System.Drawing.Size(35, 20)
    $helpMenu.Text = "&Help"
    # ADD FILE TO MENU
    $menuStrip.Items.AddRange(@($fileMenu,$helpMenu))
    # MENU DROPDOWN - FILE - OPEN
    $openItem = New-Object System.Windows.Forms.ToolStripMenuItem
    $openItem.Text = "&Open"
    [void] $fileMenu.DropDownItems.Add($openItem)
    # MENU DROPDOWN - FILE - EXIT
    $exitItem = New-Object System.Windows.Forms.ToolStripMenuItem
    $exitItem.Text = "E&xit"
    [void] $fileMenu.DropDownItems.Add($exitItem)
    # MENU DROPDOWN - HELP - ABOUT
    $aboutItem = New-Object System.Windows.Forms.ToolStripMenuItem
    $aboutItem.Text = "&About"
    [void] $helpMenu.DropDownItems.Add($aboutItem)
    # MENU DROPDOWN FUNCTIONS
    $openItem.Add_Click({
        $FileBrowser = New-Object System.Windows.Forms.OpenFileDialog
        $FileBrowser.Title = 'Select .ini file...'
        #$FileBrowser.InitialDirectory = [Environment]::CurrentDirectory
        $FileBrowser.InitialDirectory = $psScriptPath
        $FileBrowser.Filter = 'Config Files (*.ini)|*.ini'
        $null = $FileBrowser.ShowDialog() | Out-Null
        $Location = $FileBrowser.FileName
        if ((-not [string]::IsNullOrWhiteSpace($Location)) -and ((Test-Path $Location -PathType Leaf) -eq $true)) {
            $global:configFile = $Location
            Write-Host "Set config file to: $($global:configFile)"
            loadConfig -FilePath $global:configFile
        }
    })
    $exitItem.Add_Click({
        # EXIT
        $form.Close()
    })
    $aboutItem.Add_Click({
        [void][System.Windows.Forms.MessageBox]::Show("Created by Brandon Bundy`nSupport is not provided, use-at-your-own-risk!","About", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information, [System.Windows.Forms.MessageBoxDefaultButton]::Button1, [System.Windows.Forms.MessageBoxOptions]::RightAlign)#  -bor [System.Windows.Forms.MessageBoxOptions]::RtlReading
    })
    #
    # BOTTOM STATUS BAR
    #
    #$statusBar = New-Object System.Windows.Forms.StatusStrip
    #$statusBar.Dock = "Bottom"
    #$statusLabel = New-Object System.Windows.Forms.ToolStripStatusLabel
    #$statusLabel.Text = "  ..."
    #$statusBar.Items.Add($statusLabel)
    #$form.Controls.Add($statusBar)
    $bottomBar = New-Object System.Windows.Forms.Panel
    $bottomBar.Height = 20
    $bottomBar.Dock = "Bottom"
    $bottomBar.BackColor = "LightGray"
    $statusLabel = New-Object System.Windows.Forms.Label
    $statusLabel.Location = New-Object System.Drawing.Point(15, 2)
    $statusLabel.Size = New-Object System.Drawing.Size(550,20)
    $statusLabel.Text = "  ..."
    $bottomBar.Controls.Add($statusLabel)
    $form.Controls.Add($bottomBar)
    
    #
    #
    # LEFT SECTION 
    #
    #
    
    $xoffset = 20
    $yoffset = 28
    
    $newButton = New-Object System.Windows.Forms.Button
    $newButton.Location = New-Object System.Drawing.Point(($xoffset), $yoffset)
    $newButton.Size = New-Object System.Drawing.Size(100, 25)
    $newButton.Text = "Delete Profile"
    $newButton.Add_Click({
        # DESELECT PROFILE
        clearProfile
        deleteProfile -FilePath $global:configFile -SectionName $listProfiles.SelectedItem
        $listProfiles.Items.Remove($listProfiles.SelectedItem)
        $listProfiles.ClearSelected()
    })
    $form.Controls.Add($newButton)
    
    $newButton = New-Object System.Windows.Forms.Button
    $newButton.Location = New-Object System.Drawing.Point(($xoffset+160), $yoffset)
    $newButton.Size = New-Object System.Drawing.Size(100, 25)
    $newButton.Text = "Clear Profile"
    $newButton.Add_Click({
        clearProfile
        $listProfiles.ClearSelected()
    })
    $form.Controls.Add($newButton)
    
    $yoffset += 30
    
    # LIST BOX
    $listProfiles = New-Object System.Windows.Forms.ListBox
    $listProfiles.Location = New-Object System.Drawing.Point($xoffset, $yoffset)
    $listProfiles.Size = New-Object System.Drawing.Size(260,580)
    $listProfiles.SelectionMode = "One"
    $listProfiles.Sorted = $true
	#$listProfiles.ScrollAlwaysVisible = $true
    $listProfiles.Font = New-Object System.Drawing.Font("Arial", 12)
    $listProfiles.Add_Click({ if (-not [string]::IsNullOrWhiteSpace($listProfiles.SelectedItem)) { loadProfile -selectedItem $listProfiles.SelectedItem } })
    # CANT USE Add_SelectedIndexChanged BECAUSE ON SAVE IT WILL CHANGE THE SELECTED INDEX AND TRIGGER BEFORE IT CAN BE SAVED
    #$listProfiles.Add_SelectedIndexChanged({ if (-not [string]::IsNullOrWhiteSpace($listProfiles.SelectedItem)) { loadProfile -selectedItem $listProfiles.SelectedItem } })
    $form.Controls.Add($listProfiles)
    
    #
    #
    # RIGHT SECTION
    #
    #
    
    $xoffset = 300
    $yoffset = 28
    
    $profileLabel = New-Object System.Windows.Forms.Label
    $profileLabel.Location = New-Object System.Drawing.Point($xoffset, ($yoffset+4))
    $profileLabel.Size = New-Object System.Drawing.Size(50, 20)
    $profileLabel.Text = "Profile:"
    $profileLabel.Add_Click({$profileTextBox.Focus()})
    $form.Controls.Add($profileLabel)
    
    $profileTextBox = New-Object System.Windows.Forms.TextBox
    $profileTextBox.Location = New-Object System.Drawing.Point(($xoffset+70), $yoffset)
    $profileTextBox.Size = New-Object System.Drawing.Size(180, 20)
    $form.Controls.Add($profileTextBox)
    
    $yoffset += 25
    
    $dropdownAdapters = New-Object System.Windows.Forms.ComboBox
    $dropdownAdapters.Location = New-Object System.Drawing.Point($xoffset, $yoffset)
    $dropdownAdapters.Size = New-Object System.Drawing.Size(220, 25)
    $dropdownAdapters.DropDownStyle = "DropDownList" # Prevents user from typing in the box
    $dropdownAdapters.DisplayMember = "Text"
    $dropdownAdapters.ValueMember = "Value"
    $dropdownAdapters.Add_SelectedIndexChanged({
        if (-not [string]::IsNullOrWhiteSpace($dropdownAdapters.SelectedItem.Value)) {
            # UDPATE NETWORK ADAPTER DISPLAY
            $selectedSplit = ($dropdownAdapters.SelectedItem.Value).Split("|")
            updateNetworkInfo -selectedSplit $selectedSplit
        }
    })
    function updateNetworkInfo {
        param(
            [Parameter(Mandatory=$true)]
            [string[]]$selectedSplit
        )
        #$adapter_net = Get-NetAdapter -InterfaceIndex $selectedSplit[0] -ErrorAction SilentlyContinue
        $adapter_net = Get-NetAdapter -Name $selectedSplit[2] -ErrorAction SilentlyContinue
        $adapter_int = Get-NetIPInterface -InterfaceIndex $adapter_net.InterfaceIndex -AddressFamily $selectedSplit[1] -ErrorAction SilentlyContinue
        $adapter_ip = Get-NetIPAddress -InterfaceIndex $adapter_net.InterfaceIndex -AddressFamily $selectedSplit[1] -ErrorAction SilentlyContinue
        #$adapter_ipc = Get-NetIPConfiguration -InterfaceIndex $selectedSplit[0] -ErrorAction SilentlyContinue
        $adapter_dns = Get-DnsClientServerAddress -InterfaceIndex $adapter_net.InterfaceIndex -AddressFamily $selectedSplit[1] -ErrorAction SilentlyContinue
        # ALL THIS TO GET DHCP SERVER?? REALLY??
        $adap = Get-WmiObject -Class Win32_NetworkAdapterConfiguration -ErrorAction SilentlyContinue | Where-Object {$_.IPAddress -eq (Get-NetIPAddress -InterfaceIndex $adapter_net.InterfaceIndex -AddressFamily $selectedSplit[1]).IPAddress}
        $adapIndex = Get-WmiObject -Class Win32_NetworkAdapter | Where-Object {$_.Index -eq $adap.Index} | Select-Object -ExpandProperty Index
        $dhcp_server = Get-CimInstance Win32_NetworkAdapterConfiguration -Filter "Index=$adapIndex" -ErrorAction SilentlyContinue | Select -ExpandProperty DHCPServer
        if ($selectedSplit[1] -eq "IPv4") {
            $subnetMask = Convert-CidrToSubnetMask -CIDR $adapter_ip.PrefixLength
        } else {
            $subnetMask = ""
        }

        # GET DHCP DEFAULT GATEWAY
        $adapter_gateway = ""
        if (Test-Path "Registry::HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces\$(($adapter_net | Select-Object -ExpandProperty InterfaceGuid))") {
            $adapter_gateway = (Get-ItemProperty -Path "Registry::HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces\$(($adapter_net | Select-Object -ExpandProperty InterfaceGuid))" -Name "DhcpDefaultGateway").DhcpDefaultGateway
        }
        if ([string]::IsNullOrWhiteSpace($adapter_gateway)) {
            if (Test-Path "Registry::HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces\$(($adapter_net | Select-Object -ExpandProperty InterfaceGuid))") {
                $adapter_gateway = (Get-ItemProperty -Path "Registry::HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces\$(($adapter_net | Select-Object -ExpandProperty InterfaceGuid))" -Name "DefaultGateway").DefaultGateway
            }
        }

        # [TODO] LOOK INTO PULLING MORE DATA FROM THE REGISTRY SINCE IT IS FASTER!
        $adapter_dns_nameserver = ""
        if (Test-Path "Registry::HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces\$(($adapter_net | Select-Object -ExpandProperty InterfaceGuid))") {
            $adapter_dns_nameserver = (Get-ItemProperty -Path "Registry::HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces\$(($adapter_net | Select-Object -ExpandProperty InterfaceGuid))" -Name "NameServer").NameServer
        }
        
        #write-host $adapter_dns.AddressProperties.AddressState
        
        #$interfaceKeyPath = "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces\$($adapter_int.InterfaceIdentifier)"
    
        # UPDATE VALUES ON THE FORM
        $currAdapterLabel.Text       = "Adapter: " + $adapter_net.InterfaceDescription
        $currStateLabel.Text         = "State: " + ("Down","Up")[$adapter_net.InterfaceOperationalStatus -eq 1]
        $currMACLabel.Text           = "MAC Address: " + $adapter_net.MacAddress
        $currIpAssignmentLabel.Text  = "IP Assignment: " + ("Static","Automatic")[$adapter_int.Dhcp -eq "Enabled"]
        $currIpLabel.Text            = "IP Address: " + $adapter_ip.IPAddress
        # THIS IS IPv4 ONLY... IPv6 PrefixLength IS NOT THE SUBNETMASK!!!
        $currSubnetLabel.Text        = "Subnet Mask: " + $subnetMask
        #$currGatewayLabel.Text       = "Gateway: " + ($adapter_ipc.IPv6DefaultGateway, ($adapter_ipc.IPv4DefaultGateway | Where-Object {$_.DestinationPrefix -eq '0.0.0.0/0'} | Select-Object -ExpandProperty NextHop))[$selectedSplit[1] -eq "IPv4"]
        $currGatewayLabel.Text       = "Gateway: " + $adapter_gateway
        $currDNSAssignmentLabel.Text = "DNS Assignment: " + ("Static","Automatic")[[string]::IsNullOrWhiteSpace($adapter_dns_nameserver)]
        $currDNS1Label.Text          = "DNS 1:   " + $adapter_dns.ServerAddresses[0]
        $currDNS2Label.Text          = "DNS 2:   " + $adapter_dns.ServerAddresses[1]
        $currDHCPLabel.Text          = "DHCP Server:    " + $dhcp_server
    }
    # THIS DOES NOT WORK!!
    #function ConvertTo-SubnetMask {
    #    param([int]$PrefixLength)
    #    $mask = 0xFFFFFFFF -shl (32 - $PrefixLength)
    #    return [ipaddress]::Parse(($mask -shr 24) + "." + (($mask -shr 16) -band 0xFF) + "." + (($mask -shr 8) -band 0xFF) + "." + ($mask -band 0xFF)).IPAddressToString
    #}
    function Convert-CidrToSubnetMask {
        param(
            [Parameter(Mandatory=$true)]
            [int]$CIDR
        )
        $binaryMask = ("1" * $CIDR).PadRight(32, "0")
        $octet1 = [Convert]::ToInt32($binaryMask.Substring(0, 8), 2)
        $octet2 = [Convert]::ToInt32($binaryMask.Substring(8, 8), 2)
        $octet3 = [Convert]::ToInt32($binaryMask.Substring(16, 8), 2)
        $octet4 = [Convert]::ToInt32($binaryMask.Substring(24, 8), 2)
        return "$octet1.$octet2.$octet3.$octet4"
    }
    function Convert-SubnetMaskToCidr {
        param(
            [Parameter(Mandatory=$true)]
            [string]$IPAddress
        )
        $result = 0;
        [IPAddress] $ip = $IPAddress;
        $octets = $ip.IPAddressToString.Split('.');
        foreach($octet in $octets) {
            while(0 -ne $octet) {
                $octet = ($octet -shl 1) -band [byte]::MaxValue
                $result++; 
            }
        }
        return "$result"
    }
    
    $form.Controls.Add($dropdownAdapters)
    # GET SELECTED ITEM WITH: $dropdownAdapters.SelectedItem
    
    function refreshAdapters {
        $prevSelected = $dropdownAdapters.SelectedItem
        #Write-Host $prevSelected
        #Write-Host $prevSelected.Text
        #Write-Host $prevSelected.Value
        $dropdownAdapters.Items.Clear()
        #$adapters = Get-NetAdapter -Name * | Sort-Object @{Expression="Status";Descending=$true}, @{Expression="Name";Ascending=$true}
        # [TODO ADD RADIO TO SELECT TYPE] CURRENTLY LOCKED INTO IPV4
		$adapters = Get-NetIPInterface -AddressFamily "IPv4" | Select-Object AddressFamily,InterfaceAlias,InterfaceIndex,ConnectionState | Sort-Object @{Expression="AddressFamily";Ascending=$true}, @{Expression="ConnectionState";Ascending=$true}, @{Expression="InterfaceAlias";Ascending=$true}
        #Write-Host $adapters
        foreach ($adapter in $adapters) {
            #[void] $dropdownAdapters.Items.Add([pscustomobject]@{Text = "[" + $adapter.AddressFamily + "] " + $adapter.InterfaceAlias + " [" + [string]$adapter.InterfaceIndex + "]"; Value = [string]$adapter.InterfaceIndex + "|" + $adapter.AddressFamily + "|" + $adapter.InterfaceAlias})
            [void] $dropdownAdapters.Items.Add([pscustomobject]@{Text = $adapter.InterfaceAlias; Value = [string]$adapter.InterfaceIndex + "|" + $adapter.AddressFamily + "|" + $adapter.InterfaceAlias})
        }
        # KEEP THE PREVIOUSLY SELECTED OPTION SELECTED
        $dropdownAdapters.Text = $prevSelected.Text
    }
    refreshAdapters
    $refreshButton = New-Object System.Windows.Forms.Button
    $refreshButton.Location = New-Object System.Drawing.Point(($xoffset+220), $yoffset)
    $refreshButton.Size = New-Object System.Drawing.Size(30, 20)
    #$refreshButton.Text = "Refresh"
    ######
    $iconBase64 = "Qk2KBAAAAAAAAIoAAAB8AAAAEAAAABAAAAABACAAAwAAAAAEAAAAAAAAAAAAAAAAAAAAAAAAAAD/AAD/AAD/AAAAAAAA/0JHUnOPwvUoUbgeFR6F6wEzMzMTZmZmJmZmZgaZmZkJPQrXAyhcjzIAAAAAAAAAAAAAAAAEAAAAAAAAAAAAAAAAAAAABE8A/wRPAP8ETwD/BE8A/wRPAP8ETwD/BE8A/wRPAP8ETwD/BE8A/wRPAP8ETwD/BE8A/wRPAP8ETwD/BE8A/wVhAP8FYQD/BWEA/wVhAP8FYQD/BWEA/wVhAP8FYQD/BWEA/wVhAP8FYQD/BWEA/wVhAP8FYQD/BWEA/wVhAP8FYQD/BWEA/wVhAP8FYQD/BWEA/wVhAP8FYQD/BWEA/wVhAP8QJA//BWEA/wVhAP8FYQD/BWEA/wVhAP8FYQD/BXAA/wVwAP8FcAD/BXAA/wVwAP8FcAD/BXAA/wVwAP8DNgD/BXAA/wVwAP8FcAD/BXAA/wVwAP8FcAD/BXAA/wVwAP8FcAD/u/+4/7v/uP+7/7j/u/+4/7v/uP8DNgD/AzYA/wM2AP8DNgD/AzYA/wM2AP8DNgD/BXAA/wVwAP8HhwD/u/+4/7v/uP8HhwD/B4cA/weHAP8HhwD/B4cA/wM2AP8HhwD/B4cA/weHAP8HhwD/AzYA/wM2AP8HhwD/B4cA/7v/uP+7/7j/B4cA/weHAP8HhwD/B4cA/weHAP8HhwD/AzYA/weHAP8HhwD/B4cA/wM2AP8DNgD/B4cA/wePAP+7/7j/u/+4/wePAP8VmQ7/B48A/wePAP8HjwD/B48A/wePAP8HjwD/FZkO/xWZDv8DNgD/AzYA/xWZDv8VmQ7/u/+4/7v/uP8VmQ7/FZkO/xWZDv8VmQ7/FZkO/xWZDv8VmQ7/FZkO/xWZDv8VmQ7/AzYA/wM2AP8VmQ7/FZkO/7v/uP+7/7j/FZkO/xWZDv8VmQ7/FZkO/7v/uP8VmQ7/FZkO/xWZDv8VmQ7/FZkO/wM2AP8DNgD/FZkO/y6rJ/+7/7j/u/+4/y6rJ/8uqyf/Lqsn/y6rJ/8uqyf/u/+4/y6rJ/8uqyf/Lqsn/y6rJ/8DNgD/AzYA/y6rJ/8uqyf/Lqsn/7v/uP+7/7j/u/+4/7v/uP+7/7j/u/+4/7v/uP+7/7j/AzYA/wM2AP8DNgD/AzYA/y6rJ/8uqyf/PLo2/zy6Nv88ujb/PLo2/zy6Nv88ujb/PLo2/zy6Nv+7/7j/PLo2/zy6Nv88ujb/PLo2/zy6Nv88ujb/PLo2/zy6Nv88ujb/PLo2/zy6Nv88ujb/PLo2/zy6Nv+W6JL/PLo2/zy6Nv88ujb/PLo2/zy6Nv88ujb/PLo2/zy6Nv9azFT/WsxU/1rMVP9azFT/WsxU/1rMVP9azFT/WsxU/1rMVP9azFT/WsxU/1rMVP9azFT/WsxU/1rMVP9azFT/WsxU/1rMVP9azFT/WsxU/1rMVP9azFT/WsxU/1rMVP9azFT/WsxU/1rMVP9azFT/WsxU/1rMVP9azFT/WsxU/w=="
    $iconBytes = [Convert]::FromBase64String($iconBase64)
    $memoryStream = [System.IO.MemoryStream]::new($iconBytes, 0, $iconBytes.Length)
    $icon = [System.Drawing.Icon]::FromHandle(([System.Drawing.Bitmap]::new($memoryStream)).GetHIcon())
    $memoryStream.Dispose()
    #$refreshButton.BackgroundImage = $icon.ToBitmap()
    #$refreshButton.BackgroundImageLayout = [System.Windows.Forms.ImageLayout]::Stretch
    $refreshButton.Image = $icon.ToBitmap()
    $refreshButton.ImageAlign = 'MiddleCenter' # Optional: Adjust icon position
    #$refreshButton.TextImageRelation = 'ImageBeforeText' # Optional: Arrange text and image
    $refreshButton.AutoSize = $true # Optional: Adjust button size to fit content
    ######
    $refreshButton.Add_Click({refreshAdapters})
    $form.Controls.Add($refreshButton)
    
    $yoffset += 30
    
    $sub_yoffset = 20
    $currAdapterLabel = New-Object System.Windows.Forms.TextBox
    $currAdapterLabel.Location = New-Object System.Drawing.Point(10,$sub_yoffset)
    $currAdapterLabel.Size = New-Object System.Drawing.Size(230, 35)
    $currAdapterLabel.Text = "Adapter:"
    $currAdapterLabel.ReadOnly = $true
    $currAdapterLabel.BorderStyle = "None"
    $currAdapterLabel.Multiline = $true
    $currAdapterLabel.ScrollBars = "Vertical"
    $sub_yoffset += 35
    $currStateLabel = New-Object System.Windows.Forms.TextBox
    $currStateLabel.Location = New-Object System.Drawing.Point(10,$sub_yoffset)
    $currStateLabel.Size = New-Object System.Drawing.Size(230, 20)
    $currStateLabel.Text = "State:"
    $currStateLabel.ReadOnly = $true
    $currStateLabel.BorderStyle = "None"
    $sub_yoffset += 20
    $currMACLabel = New-Object System.Windows.Forms.TextBox
    $currMACLabel.Location = New-Object System.Drawing.Point(10,$sub_yoffset)
    $currMACLabel.Size = New-Object System.Drawing.Size(230, 20)
    $currMACLabel.Text = "MAC Address:"
    $currMACLabel.ReadOnly = $true
    $currMACLabel.BorderStyle = "None"
    $sub_yoffset += 20
    $currIpAssignmentLabel = New-Object System.Windows.Forms.TextBox
    $currIpAssignmentLabel.Location = New-Object System.Drawing.Point(10,$sub_yoffset)
    $currIpAssignmentLabel.Size = New-Object System.Drawing.Size(230, 20)
    $currIpAssignmentLabel.Text = "IP Assignment:"
    $currIpAssignmentLabel.ReadOnly = $true
    $currIpAssignmentLabel.BorderStyle = "None"
    $sub_yoffset += 20
    $currIpLabel = New-Object System.Windows.Forms.TextBox
    $currIpLabel.Location = New-Object System.Drawing.Point(10,$sub_yoffset)
    $currIpLabel.Size = New-Object System.Drawing.Size(230, 20)
    $currIpLabel.Text = "IP Address:"
    $currIpLabel.ReadOnly = $true
    $currIpLabel.BorderStyle = "None"
    $sub_yoffset += 20
    $currSubnetLabel = New-Object System.Windows.Forms.TextBox
    $currSubnetLabel.Location = New-Object System.Drawing.Point(10,$sub_yoffset)
    $currSubnetLabel.Size = New-Object System.Drawing.Size(230, 20)
    $currSubnetLabel.Text = "Subnet Mask:"
    $currSubnetLabel.ReadOnly = $true
    $currSubnetLabel.BorderStyle = "None"
    $sub_yoffset += 20
    $currGatewayLabel = New-Object System.Windows.Forms.TextBox
    $currGatewayLabel.Location = New-Object System.Drawing.Point(10,$sub_yoffset)
    $currGatewayLabel.Size = New-Object System.Drawing.Size(230, 20)
    $currGatewayLabel.Text = "Gateway:"
    $currGatewayLabel.ReadOnly = $true
    $currGatewayLabel.BorderStyle = "None"
    $sub_yoffset += 20
    $currDNSAssignmentLabel = New-Object System.Windows.Forms.TextBox
    $currDNSAssignmentLabel.Location = New-Object System.Drawing.Point(10,$sub_yoffset)
    $currDNSAssignmentLabel.Size = New-Object System.Drawing.Size(230, 20)
    $currDNSAssignmentLabel.Text = "DNS Assignment:"
    $currDNSAssignmentLabel.ReadOnly = $true
    $currDNSAssignmentLabel.BorderStyle = "None"
    $sub_yoffset += 20
    $currDNS1Label = New-Object System.Windows.Forms.TextBox
    $currDNS1Label.Location = New-Object System.Drawing.Point(10,$sub_yoffset)
    $currDNS1Label.Size = New-Object System.Drawing.Size(230, 20)
    $currDNS1Label.Text = "DNS 1:"
    $currDNS1Label.ReadOnly = $true
    $currDNS1Label.BorderStyle = "None"
    $sub_yoffset += 20
    $currDNS2Label = New-Object System.Windows.Forms.TextBox
    $currDNS2Label.Location = New-Object System.Drawing.Point(10,$sub_yoffset)
    $currDNS2Label.Size = New-Object System.Drawing.Size(230, 20)
    $currDNS2Label.Text = "DNS 2:"
    $currDNS2Label.ReadOnly = $true
    $currDNS2Label.BorderStyle = "None"
    $sub_yoffset += 20
    $currDHCPLabel = New-Object System.Windows.Forms.TextBox
    $currDHCPLabel.Location = New-Object System.Drawing.Point(10,$sub_yoffset)
    $currDHCPLabel.Size = New-Object System.Drawing.Size(230, 20)
    $currDHCPLabel.Text = "DHCP Server:"
    $currDHCPLabel.ReadOnly = $true
    $currDHCPLabel.BorderStyle = "None"
    
    $statusBox = New-Object System.Windows.Forms.GroupBox
    $statusBox.Location = New-Object System.Drawing.Point($xoffset, $yoffset)
    $statusBox.Size = New-Object System.Drawing.Size(250, 260)
    $statusBox.Text = "Current Settings"
    $statusBox.Controls.AddRange(@($currAdapterLabel,$currStateLabel,$currMACLabel,$currIpAssignmentLabel,$currIpLabel,$currSubnetLabel,$currGatewayLabel,$currDNSAssignmentLabel,$currDNS1Label,$currDNS2Label,$currDHCPLabel))
    $form.Controls.Add($statusBox)
    
    $yoffset += 265
    
    $radioIPAuto = New-Object System.Windows.Forms.RadioButton
    $radioIPAuto.Text = "Automatic"
    $radioIPAuto.Location = New-Object System.Drawing.Point(20, 20)
    $radioIPAuto.Size = New-Object System.Drawing.Size(100, 20)
    $radioIPAuto.Checked = $true
    #$radioIPAuto.Add_Click({$ipTextBox.Enabled=$subnetTextBox.Enabled=$gatewayTextBox.Enabled=$false;})
    $radioIPAuto.Add_CheckedChanged({$ipTextBox.Enabled=$subnetTextBox.Enabled=$gatewayTextBox.Enabled=$false})
    
    $radioIPStatic = New-Object System.Windows.Forms.RadioButton
    $radioIPStatic.Text = "Static"
    $radioIPStatic.Location = New-Object System.Drawing.Point(130, 20)
    $radioIPStatic.Size = New-Object System.Drawing.Size(80, 20)
    #$radioIPStatic.Add_Click({$ipTextBox.Enabled=$subnetTextBox.Enabled=$gatewayTextBox.Enabled=$true;})
    $radioIPStatic.Add_CheckedChanged({$ipTextBox.Enabled=$subnetTextBox.Enabled=$gatewayTextBox.Enabled=$true;if($radioIPStatic.Checked -eq $true){$radioDNSStatic.Checked=$true}})
    
    $IPConnBox = New-Object System.Windows.Forms.GroupBox
    $IPConnBox.Location = New-Object System.Drawing.Point($xoffset, $yoffset)
    $IPConnBox.Size = New-Object System.Drawing.Size(250, 50)
    $IPConnBox.Text = "IP Assignment"
    $IPConnBox.Controls.AddRange(@($radioIPAuto,$radioIPStatic))
    $form.Controls.Add($IPConnBox)
    
    $yoffset += 60
    
    $ipLabel = New-Object System.Windows.Forms.Label
    $ipLabel.Location = New-Object System.Drawing.Point($xoffset, $yoffset)
    $ipLabel.Size = New-Object System.Drawing.Size(80, 20)
    $ipLabel.Text = "IP Address:"
    $ipLabel.Add_Click({$ipTextBox.Focus()})
    $form.Controls.Add($ipLabel)
    
    $ipTextBox = New-Object System.Windows.Forms.TextBox
    $ipTextBox.Location = New-Object System.Drawing.Point(($xoffset+80), $yoffset)
    $ipTextBox.Size = New-Object System.Drawing.Size(170, 20)
    $ipTextBox.Enabled = $false
    $form.Controls.Add($ipTextBox)
    
    $yoffset += 30
    
    $subnetLabel = New-Object System.Windows.Forms.Label
    $subnetLabel.Location = New-Object System.Drawing.Point($xoffset, $yoffset)
    $subnetLabel.Size = New-Object System.Drawing.Size(80, 20)
    $subnetLabel.Text = "Netmask:"
    $subnetLabel.Add_Click({$subnetTextBox.Focus()})
    $subnetLabel.Add_MouseHover({$toolTip.SetToolTip($subnetLabel, "Subnet Mask")})
    $form.Controls.Add($subnetLabel)
    
    $subnetTextBox = New-Object System.Windows.Forms.TextBox
    $subnetTextBox.Location = New-Object System.Drawing.Point(($xoffset+80), $yoffset)
    $subnetTextBox.Size = New-Object System.Drawing.Size(170, 20)
    $subnetTextBox.Enabled = $false
    $form.Controls.Add($subnetTextBox)
    
    $yoffset += 30
    
    $gatewayLabel = New-Object System.Windows.Forms.Label
    $gatewayLabel.Location = New-Object System.Drawing.Point($xoffset, $yoffset)
    $gatewayLabel.Size = New-Object System.Drawing.Size(80, 20)
    $gatewayLabel.Text = "Gateway:"
    $gatewayLabel.Add_Click({$gatewayTextBox.Focus()})
    $form.Controls.Add($gatewayLabel)
    
    $gatewayTextBox = New-Object System.Windows.Forms.TextBox
    $gatewayTextBox.Location = New-Object System.Drawing.Point(($xoffset+80), $yoffset)
    $gatewayTextBox.Size = New-Object System.Drawing.Size(170, 20)
    $gatewayTextBox.Enabled = $false
    $form.Controls.Add($gatewayTextBox)
    
    $yoffset += 30
    
    $radioDNSAuto = New-Object System.Windows.Forms.RadioButton
    $radioDNSAuto.Text = "Automatic"
    $radioDNSAuto.Location = New-Object System.Drawing.Point(20, 20)
    $radioDNSAuto.Size = New-Object System.Drawing.Size(100, 20)
    $radioDNSAuto.Checked = $true
    #$radioDNSAuto.Add_Click({$dnsTextBox1.Enabled=$dnsTextBox2.Enabled=$false;})
    $radioDNSAuto.Add_CheckedChanged({$dnsTextBox1.Enabled=$dnsTextBox2.Enabled=$false;if($radioDNSAuto.Checked -eq $true){$radioIPAuto.Checked=$true}})
    
    $radioDNSStatic = New-Object System.Windows.Forms.RadioButton
    $radioDNSStatic.Text = "Static"
    $radioDNSStatic.Location = New-Object System.Drawing.Point(130, 20)
    $radioDNSStatic.Size = New-Object System.Drawing.Size(80, 20)
    #$radioDNSStatic.Add_Click({$dnsTextBox1.Enabled=$dnsTextBox2.Enabled=$true;})
    $radioDNSStatic.Add_CheckedChanged({$dnsTextBox1.Enabled=$dnsTextBox2.Enabled=$true})
    
    $DNSConnBox = New-Object System.Windows.Forms.GroupBox
    $DNSConnBox.Location = New-Object System.Drawing.Point($xoffset, $yoffset)
    $DNSConnBox.Size = New-Object System.Drawing.Size(250, 50)
    $DNSConnBox.Text = "DNS Assignment"
    $DNSConnBox.Controls.AddRange(@($radioDNSAuto,$radioDNSStatic))
    $form.Controls.Add($DNSConnBox)
    
    $yoffset += 57
    
    $dnsLabel1 = New-Object System.Windows.Forms.Label
    $dnsLabel1.Location = New-Object System.Drawing.Point($xoffset, $yoffset)
    $dnsLabel1.Size = New-Object System.Drawing.Size(80, 20)
    $dnsLabel1.Text = "DNS 1:"
    $dnsLabel1.Add_Click({$dnsTextBox1.Focus()})
    $form.Controls.Add($dnsLabel1)
    
    $dnsTextBox1 = New-Object System.Windows.Forms.TextBox
    $dnsTextBox1.Location = New-Object System.Drawing.Point(($xoffset+80), $yoffset)
    $dnsTextBox1.Size = New-Object System.Drawing.Size(170, 20)
    $dnsTextBox1.Enabled = $false
    $form.Controls.Add($dnsTextBox1)
    
    $yoffset += 27
    
    $dnsLabel2 = New-Object System.Windows.Forms.Label
    $dnsLabel2.Location = New-Object System.Drawing.Point($xoffset, $yoffset)
    $dnsLabel2.Size = New-Object System.Drawing.Size(80, 20)
    $dnsLabel2.Text = "DNS 2:"
    $dnsLabel2.Add_Click({$dnsTextBox2.Focus()})
    $form.Controls.Add($dnsLabel2)
    
    $dnsTextBox2 = New-Object System.Windows.Forms.TextBox
    $dnsTextBox2.Location = New-Object System.Drawing.Point(($xoffset+80), $yoffset)
    $dnsTextBox2.Size = New-Object System.Drawing.Size(170, 20)
    $dnsTextBox2.Enabled = $false
    $form.Controls.Add($dnsTextBox2)
    
    #$yoffset += 30
    
    #$dnsLabel3 = New-Object System.Windows.Forms.Label
    #$dnsLabel3.Location = New-Object System.Drawing.Point($xoffset, $yoffset)
    #$dnsLabel3.Size = New-Object System.Drawing.Size(80, 20)
    #$dnsLabel3.Text = "DNS Suffix:"
    #$dnsLabel3.Add_Click({$dnsTextBox3.Focus()})
    #$form.Controls.Add($dnsLabel3)
    
    #$dnsTextBox3 = New-Object System.Windows.Forms.TextBox
    #$dnsTextBox3.Location = New-Object System.Drawing.Point(($xoffset+80), $yoffset)
    #$dnsTextBox3.Size = New-Object System.Drawing.Size(170, 20)
    #$dnsTextBox3.Enabled = $false
    #$form.Controls.Add($dnsTextBox3)
    
    $yoffset += 25
    
    $saveButton = New-Object System.Windows.Forms.Button
    $saveButton.Location = New-Object System.Drawing.Point($xoffset, $yoffset)
    $saveButton.Size = New-Object System.Drawing.Size(100, 30)
    $saveButton.Text = "Save"
    $saveButton.Add_Click({
        if ($profileTextBox.Text.Length -gt 0) {
            $selectedSplit = ($dropdownAdapters.SelectedItem.Value).Split("|")
            $SectionData = [ordered]@{
                AdapterName = $dropdownAdapters.SelectedItem.Text
                AdapterAlias = $selectedSplit[2]
                InterfaceIndex = $selectedSplit[0]
                AddressFamily = $selectedSplit[1]
                IPAssignment = ("Static","Automatic")[$radioIPAuto.Checked -eq $true]
                IPAddress = $ipTextBox.Text
                Subnet = $subnetTextBox.Text
                Gateway = $gatewayTextBox.Text
                DNSAssignment = ("Static","Automatic")[$radioDNSAuto.Checked -eq $true]
                DNS1 = $dnsTextBox1.Text
                DNS2 = $dnsTextBox2.Text
                #DNSSearch = $dnsTextBox3.Text
            }
            Write-IniContent -FilePath $global:configFile -SectionName $profileTextBox.Text -SectionData $SectionData
        } else {
            [void][System.Windows.Forms.MessageBox]::Show("Profile name cannot be empty.","Empty Profile Name")
        }
    })
    $form.Controls.Add($saveButton)
    
    $applyButton = New-Object System.Windows.Forms.Button
    $applyButton.Location = New-Object System.Drawing.Point(($xoffset+150), $yoffset)
    $applyButton.Size = New-Object System.Drawing.Size(100, 30)
    $applyButton.Text = "Apply"
    #$applyButton.BackColor = [System.Drawing.Color]::LawnGreen
    $applyButton.BackColor = [System.Drawing.Color]::FromArgb(115, 247, 115)
    $applyButton.Add_Click({
        
        # GET SUBNET CIDR FROM IP
        # Convert-SubnetMaskToCidr -IPAddress "255.255.255.0"
        
        # VALIDATE IP
        if ($radioIPStatic.Checked -eq $true) {
            if (-not [string]::IsNullOrWhiteSpace($ipTextBox.Text)) {
				try {
					$validip = [ipaddress]::Parse($ipTextBox.Text)
				} catch {
					[void][System.Windows.Forms.MessageBox]::Show("Invalid IP Address","Invalid IP")
					return
				}
			}
			if (-not [string]::IsNullOrWhiteSpace($subnetTextBox.Text)) {
				try {
					$validip = [ipaddress]::Parse($subnetTextBox.Text)
				} catch {
					[void][System.Windows.Forms.MessageBox]::Show("Invalid Subnet Mask","Invalid IP")
					return
				}
			}
        }
		if ($radioDNSStatic.Checked -eq $true) {
			if (-not [string]::IsNullOrWhiteSpace($dnsTextBox1.Text)) {
				try {
					$validip = [ipaddress]::Parse($dnsTextBox1.Text)
				} catch {
					[void][System.Windows.Forms.MessageBox]::Show("Invalid DNS1","Invalid IP")
					return
				}
			}
			if (-not [string]::IsNullOrWhiteSpace($dnsTextBox2.Text)) {
				try {
					$validip = [ipaddress]::Parse($dnsTextBox2.Text)
				} catch {
					[void][System.Windows.Forms.MessageBox]::Show("Invalid DNS2","Invalid IP")
					return
				}
			}
		}

        $selectedSplit = ($dropdownAdapters.SelectedItem.Value).Split("|")
        $netadapter = Get-NetAdapter -InterfaceIndex $selectedSplit[0]
        $interface = $netadapter | Get-NetIPInterface -AddressFamily $selectedSplit[1]
        # $netAdapter.InterfaceAlias

        # REMOVE ANY EXISTING IP, GATEWAY FROM OUR ADAPTER
        #if (($netadapter | Get-NetIPConfiguration).IPv4Address.IPAddress) {
        $netadapter | Remove-NetIPAddress -AddressFamily $selectedSplit[1] -Confirm:$false -ErrorAction SilentlyContinue
        #}
        #if (($netadapter | Get-NetIPConfiguration).Ipv4DefaultGateway) {
        $interface | Remove-NetRoute -Confirm:$false -ErrorAction SilentlyContinue
        #}

        # IP ADDRESS
        if ($radioIPAuto.Checked -eq $true) {
            $interface | Set-NetIPInterface -Dhcp Enabled -Confirm:$false
            # THIS GETS SET AUTOMATICALLY ANYWAY ???
            #Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\services\Tcpip\Parameters\Interfaces\$($netadapter.InterfaceGuid)" -Name EnableDHCP -Value 1
        } else {
            $interface | Set-NetIPInterface -Dhcp Disabled -Confirm:$false
            # THIS GETS SET AUTOMATICALLY ANYWAY ???
            #Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\services\Tcpip\Parameters\Interfaces\$($netadapter.InterfaceGuid)" -Name EnableDHCP -Value 0
            #Write-Host "[0]: $($selectedSplit[0]) [1]: $($selectedSplit[1]) IP: $($ipTextBox.Text) Subnet: $((Convert-SubnetMaskToCidr -IPAddress $subnetTextBox.Text)) Gateway: $($gatewayTextBox.Text)"
            if ([string]::IsNullOrWhiteSpace($gatewayTextBox.Text)) {
                $null = $netadapter | New-NetIPAddress -AddressFamily $selectedSplit[1] -IPAddress $ipTextBox.Text -PrefixLength ((Convert-SubnetMaskToCidr -IPAddress $subnetTextBox.Text)) -Confirm:$false
            } else {
                $null = $netadapter | New-NetIPAddress -AddressFamily $selectedSplit[1] -IPAddress $ipTextBox.Text -PrefixLength ((Convert-SubnetMaskToCidr -IPAddress $subnetTextBox.Text)) -DefaultGateway $gatewayTextBox.Text -Confirm:$false
            }
        }
        # DNS
        if ($radioDNSAuto.Checked -eq $true) {
            $interface | Set-DnsClientServerAddress -ResetServerAddresses
        } else {
            if (-not [string]::IsNullOrWhiteSpace($dnsTextBox2.Text)) {
                $DNSServers = $dnsTextBox1.Text + "," + $dnsTextBox2.Text
            } else {
                $DNSServers = $dnsTextBox1.Text
            }
            $interface | Set-DnsClientServerAddress -ServerAddresses $DNSServers
        }

        # REQUEST AN UPDATED IP FROM DHCP
        if ($radioIPAuto.Checked -eq $true -or $radioDNSAuto.Checked -eq $true) {
            # THIS WORKS BUT TAKES LONGER
            #$netadapter | Disable-NetAdapter -Confirm:$false
            #$netadapter | Enable-NetAdapter -Confirm:$false
            #$netadapter | Restart-NetAdapter -Confirm:$false
            ## REQUEST DHCP -- ONLY WORKED SOMETIMES
            #Get-CimInstance Win32_NetworkAdapterConfiguration -Filter "DHCPEnabled=$true" | Select DHCPServer
            ## Get-WMIObject Win32_NetworkAdapterConfiguration -Filter "DHCPEnabled=$true" | Select DHCPServer # WIN 7/2008 R2
            # REQUEST DHCP -- THIS FEELS CHEAP
            & ipconfig /release
            & ipconfig /renew
        }
        
        # NOW REFRESH THE ADAPTER INFO
        refreshAdapters

    })
    $form.Controls.Add($applyButton)
    
    #
    # FUNCTIONS
    #
    function loadProfile {
        param(
            [Parameter(Mandatory=$true)]
            [string]$selectedItem
        )
    
        $config = Get-IniContent -FilePath $global:configFile -SectionName $selectedItem.Replace('[', '\[').Replace(']', '\]')
    
        if ([string]::IsNullOrWhiteSpace($config)) { Write-Host "EMPTY CONFIG" }
    
        $profileTextBox.Text = $selectedItem
    
        $dropdownAdapters.Text = $config['AdapterName'].replace('\','')
    
        if ($config['IPAssignment'] -eq "Automatic") {
            $radioIPAuto.Checked = $true
            $ipTextBox.Text = ""
            $subnetTextBox.Text = ""
            $gatewayTextBox.Text = ""
        } else {
            $radioIPStatic.Checked = $true
            $ipTextBox.Text = $config['IPAddress']
            $subnetTextBox.Text = $config['Subnet']
            $gatewayTextBox.Text = $config['Gateway']
        }
    
        if ($config['DNSAssignment'] -eq "Automatic") {
            $radioDNSAuto.Checked = $true
            $dnsTextBox1.Text = ""
            $dnsTextBox2.Text = ""
            #$dnsTextBox3.Text = ""
        } else {
            $radioDNSStatic.Checked = $true
            $dnsTextBox1.Text = $config['DNS1']
            $dnsTextBox2.Text = $config['DNS2']
            #$dnsTextBox3.Text = $config['DNSSearch']
        }
    }
    function deleteProfile {
        param(
            [Parameter(Position=0,mandatory=$true)]
            [string]$FilePath,
            [Parameter(Position=1,mandatory=$true)]
            [string]$SectionName
        )
        $ini = Get-IniContent -FilePath $FilePath
        $ini.Remove($SectionName)
        # USE X TO EXCLUDE THE FIRST IN A FOR LOOP FROM A PREFIXED NEWLINE
        $x = 0
        $content = ""
        foreach ($section in $ini.Keys) {
            if ($x -eq 0) {
                $content += "[$section]`r`n"
            } else{
                $content += "`r`n[$section]`r`n"
            }
            foreach ($key in $ini[$section].Keys) {
                $content += "$key=$($ini[$section][$key])`r`n"
            }
            $x+=1
        }
        Set-Content -Path $FilePath -Value $content -Force
    }
    function clearProfile {
        # MUST CLEAR THE PROFILES LISTBOX SEPARATELY
        $profileTextBox.Text = ""
        $dropdownAdapters.SelectedIndex = -1
        $currAdapterLabel.Text       = "Adapter: "
        $currStateLabel.Text         = "State: "
        $currMACLabel.Text           = "MAC Address: "
        $currIpAssignmentLabel.Text  = "IP Assignment: "
        $currIpLabel.Text            = "IP Address: "
        $currSubnetLabel.Text        = "Subnet Mask: "
        $currGatewayLabel.Text       = "Gateway: "
        $currDNSAssignmentLabel.Text = "DNS Assignment: "
        $currDNS1Label.Text          = "DNS 1: "
        $currDNS2Label.Text          = "DNS 2: "
        $currDHCPLabel.Text          = "DHCP Server: "
        $radioIPAuto.Checked = $true
        $ipTextBox.Text = ""
        $subnetTextBox.Text = ""
        $gatewayTextBox.Text = ""
        $radioDNSAuto.Checked = $true
        $dnsTextBox1.Text = ""
        $dnsTextBox2.Text = ""
        #$dnsTextBox3.Text = ""
    }
    function Get-IniSections {
        param(
            [Parameter(Position=0,mandatory=$true)]
            [string]$FilePath
        )
        $sectionList = @()
        $iniContent = Get-Content -Path $FilePath -Raw
        $iniData = $iniContent -split '\r?\n(?=\[)' | ForEach-Object {
            $section = $_ -match '^\[(.*)\]'
            if ($section) {
                $sectionName = $matches[1]
                $sectionList += $sectionName.replace('\','')
                #$keyValues = $_ -split '\r?\n' | Where-Object { $_ -match '=' } | ConvertFrom-StringData
                #[pscustomobject]@{
                #    Section = $sectionName
                #    Keys = $keyValues
                #}
            }
        }
        #$iniData | ForEach-Object {
        #    Write-Host "Section: $($_.Section)"
        #    $_.Keys.PSObject.Properties | ForEach-Object {
        #        Write-Host "  Key: $($_.Name), Value: $($_.Value)"
        #    }
        #}
        return $sectionList
    }
    function Get-IniContent {
        param(
            [Parameter(Position=0,mandatory=$true)]
            [string]$FilePath,
            [string]$SectionName
        )
        $ini = [ordered]@{}
        $currentSection = $null
        $section = ""
        foreach ($line in Get-Content $FilePath) {
            $line = $line.Trim()
            
            if ($line -match "^\[(.*)\]$") {
                $section = $matches[1]
                $ini[$section] = @{}
            } elseif ($line -match "^\s*([^=]+)\s*=\s*(.*)$") {
                $key = $matches[1]
                $value = $matches[2]
                $ini[$section][$key] = $value
            }
        }
        if ($SectionName) {
            return $ini[$SectionName]
        } else {
          return $ini
        }
    }
    function Write-IniContent {
        param(
            [Parameter(Position=0,mandatory=$true)]
            [string]$FilePath,
            [Parameter(Position=1,mandatory=$true)]
            [string]$SectionName,
            [Parameter(Position=2,mandatory=$true)]
            [hashtable]$SectionData
        )
        if ((Test-Path $global:configFile -PathType Leaf) -eq $false) {
            New-Item -Path $FilePath -ItemType "file"
        }
        $existing = Get-IniContent -FilePath $FilePath -SectionName $SectionName
        Write-Host ($existing | Out-String)
    
        # GET RAW FILE CONTENTS
        $fileContent = Get-Content -Path $FilePath -Raw
    
        # BUILD INI-FORMATTED STRING
        $iniString = ""
        #   ONLY HAVE THE HEADER IF WE ARE CREATED A NEW PROFILE
        if ([string]::IsNullOrWhiteSpace($existing)) {
            $iniStringHead += "[$($SectionName -replace '\[', '\[' -replace '\]', '\]')]`r`n"
        }
        foreach ($key in $SectionData.Keys) {
            $iniString += "$key=$($SectionData[$key])`r`n"
        }
    
        if ([string]::IsNullOrWhiteSpace($existing)) {
            # CREATE NEW PROFILE
            [void] $listProfiles.Items.Add($SectionName)
            $listProfiles.SelectedItem = $SectionName
            "$($iniStringHead)$($iniString -replace '\[', '\[' -replace '\]', '\]')" | Add-Content $FilePath
        } else {
            # OVERWRITE EXISTING
            $pattern = "(?s)(?<=\[$SectionName\]\r?\n).*?(?=\r?\n\[|$)"
            $fileContent -replace $pattern, "$($iniString -replace '\[', '\[' -replace '\]', '\]')" | Set-Content $FilePath
        }
        $statusLabel.Text = "Saved Config File: $($global:configFile)"
    }
    #
    # LOAD CONFIG IF EXISTS
    #
    function loadConfig {
        param(
            [Parameter(Position=0,mandatory=$true)]
            [string]$FilePath
        )
        if ((Test-Path $FilePath -PathType Leaf) -eq $true) {
            clearProfile
            $listProfiles.ClearSelected()
            $listProfiles.Items.Clear()
            $sectionList = Get-IniSections -FilePath $FilePath
            foreach ($section in $sectionList) {
                [void] $listProfiles.Items.Add($section)
            }
            $statusLabel.Text = "Config File: $($global:configFile)"
        } else {
            $statusLabel.Text = "No config file, saving here: $($global:configFile)"
        }
    }
    loadConfig -FilePath $global:configFile
    
    
    
    $form.Add_Shown({
        $form.ActiveControl = $null # STOP AUTO FOCUS ON FIRST ELEMENT... OR USE THIS? $form.Activate()
        # HIDE CONSOLE WINDOW
        Add-Type -Name Window -Namespace Console -MemberDefinition '
            [DllImport("Kernel32.dll")]
            public static extern IntPtr GetConsoleWindow();
            [DllImport("user32.dll")]
            public static extern bool ShowWindow(IntPtr hWnd, Int32 nCmdShow);
        '
        $consolePtr = [Console.Window]::GetConsoleWindow()
        [Console.Window]::ShowWindow($consolePtr, 0)
    })
    [void]$form.ShowDialog()

} else {
	if ([System.IO.Path]::GetExtension($PSCommandPath) -eq '.ps1') {
		Start-Process -FilePath "powershell" -ArgumentList "$('-File ""')$(Get-Location)$('\')$($MyInvocation.MyCommand.Name)$('""')" -Verb runAs
	} else {
		Start-Process -FilePath "$($psScriptFullPath)" -Verb runAs
	}
}
