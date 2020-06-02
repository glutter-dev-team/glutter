# glutter  
  
A mutli-platform app for easy-to-use remote control of your linux servers built with Flutter and Glances.  
  
# Quick-Start Guide  
Install Glances on your system, you want to monitor. Have a look on https://glances.readthedocs.io/en/stable/install.html for further information. 
Having Glances installed on your System, start the Glances-integrated Webserver for providing the API for glutter. *(You may register Glances as a system-service or start it as a cronjob)*

    >> glances -w
You can now verify your server is up and running by typing

    http://YourServerAddress:61208
in your Browser. 

Please have an eye on your firewall settings. If you want to use Glances outside your LAN, please configure your firewall to open Port 61208 (be careful!) or run Glances behind a reverse-proxy. 
Running Glances with HTTPS behind a reverse-proxy is not supported by glutter yet.