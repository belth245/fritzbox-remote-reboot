###############################################################
### Autor: Jan Spengler <jan.spengler@gmx.net>                #
### Ursprung: https://github.com/nicoh88/cron_fritzbox-reboot #
###############################################################

# Skript sollte ab FritzOS 6.0 (2013) funktioneren - also auch für die 6.8x und 6.9x
# Dieses Bash-Skript nutzt das Protokoll TR-064 nicht die WEBCM-Schnittstelle

# http://fritz.box:49000/tr64desc.xml
# https://wiki.fhem.de/wiki/FRITZBOX#TR-064
# https://avm.de/service/schnittstellen/

# Thanks to Dragonfly (https://homematic-forum.de/forum/viewtopic.php?t=27994)


###=======###
# Variablen #
###=======###

$IPS = ("1.2.3.4", "2.3.4.5")

$FRITZUSER = "USERNAME"
$FRITZPW = "PASSWORD"

$credentials = New-Object System.Management.Automation.PSCredential -ArgumentList $FRITZUSER, ($FRITZPW | ConvertTo-SecureString -AsPlainText -Force)


###====###
# Skript #
###====###

$location = "/upnp/control/deviceconfig"

$uri = "urn:dslforum-org:service:DeviceConfig:1"
$action = "Reboot"

$headers = @{
    'Content-Type' = 'text/xml; charset="utf-8"';
    'SoapAction' = '{0}#{1}' -f $uri,$action
}

$xml_data = "<?xml version='1.0' encoding='utf-8'?>
             <s:Envelope s:encodingStyle='http://schemas.xmlsoap.org/soap/encoding/' xmlns:s='http://schemas.xmlsoap.org/soap/envelope/'>
               <s:Body>
                 <u:{1} xmlns:u='{0}'></u:{1}>
               </s:Body>
             </s:Envelope>" -f $uri,$action

ForEach ($ip in $IPS) {
    $resp = Invoke-WebRequest -Uri ("http://{0}:49000{1}" -f $ip,$location) -Method Post -Credential $credentials -Headers $headers -Body $xml_data -TimeoutSec 5
}