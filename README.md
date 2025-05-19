<h1>Azure Sentinel SIEM Implementation Lab for Visualizing Global Attack Data</h1>

<h2>Description</h2>

###
This project implements Azure Sentinel (SIEM) to monitor global RDP brute force attacks using a live virtual machine as a honey pot. The PowerShell script provided parses Windows Event Log information for failed RDP attacks and utilizes a third-party API to gather geographic information about attackers' locations. Azure Log Analytics Workspace ingests these logs, and through Kusto Query Language (KQL), we format and visualize the data on a world map in Azure Sentinel. The custom workbook highlights attack origins and magnitudes, providing real-time insights into global cybersecurity threats.

###
In this demo, the script facilitates real-time observation of RDP brute force attacks worldwide. It retrieves geolocation data, which is then plotted on an Azure Sentinel map. This setup enhances proactive threat detection and situational awareness, offering scalability to adapt to evolving security challenges.
<h2>Languages and Utilities Used</h2>

- <b>PowerShell</b> 
- <b>Azure Portal</b>
- <b>Microsoft Sentinel</b>
- <b>KQL</b>
- <b>Azure Log Analytics Workspace</b>
- <b>ipgeolocation.io: IP Address to Geolocation API</b>

<h2>Environment Used </h2>

- <b>Azure Virtual Machine as HoneyPot</b>

<h2>Project Overview</h2>
<p align="center">
<br/>
<img src="https://i.imgur.com/CMna52Y.jpeg" height="80%" width="80%" alt="Active Directory Administration Steps"/>
 <br />
</p>

<h2>Screenshots of Key Stages:</h2>

<p align="center">
<br />
1. Launching the honeypot-vm Virtual Machine: <br/>
<img src="https://i.imgur.com/U7QJkPw.jpeg" height="80%" width="80%" alt="Active Directory Administration Steps"/>
<br />
<br />
2. Disable Windows Firewall to make the honeypot-vm vulnerable to attackers:  <br/>
<img src="https://i.imgur.com/CMP1Qwy.jpeg" height="80%" width="80%" alt="Active Directory Administration Steps"/>
<br />
<br />
3. Using Attacker IP Address from Event Viewer in lookup tool to get Geolocation Data:  <br/>
<img src="https://i.imgur.com/kovlmno.jpeg" height="80%" width="80%" alt="Active Directory Administration Steps"/>
<br />
<br />
4. Log Exporter Powershell Script in Action (Automates process shown in previous screenshot Using API key): <br/>
<img src="https://i.imgur.com/L6IKE6l.jpeg" height="80%" width="80%" alt="Active Directory Administration Steps"/>
<br />
<br />
5. Log Analytics Workspace Raw Custom Log Data:  <br/>
<img src="https://i.imgur.com/VECGZf6.jpeg" height="80%" width="80%" alt="Active Directory Administration Steps"/>
<br />
<br />
6. Log Analytics Workspace Formatting Raw Geo-Data into Readable Columns Using Query:  <br/>
<img src="https://i.imgur.com/71yc0qK.jpeg" height="80%" width="80%" alt="Active Directory Administration Steps"/>
<br />
<br />
7. Setting up Map in Sentinel with Latitude and Longitude:  <br/>
<img src="https://i.imgur.com/CxyVZ6s.jpeg" height="80%" width="80%" alt="Active Directory Administration Steps"/>
<br />
<br />
8. Report of Failed RDP Attacks on World Map in first few hours:  <br/>
<img src="https://i.imgur.com/BcnCTA5.jpeg" height="80%" width="80%" alt="Active Directory Administration Steps"/>
<br />
<br />
9. "Report of Failed RDP Attacks on World Map 48 Hours Later:  <br/>
<img src="https://i.imgur.com/oalMIgi.jpeg" height="80%" width="80%" alt="Active Directory Administration Steps"/>
<br />
</p>

<!--
 ```diff
- text in red
+ text in green
! text in orange
# text in gray
@@ text in purple (and bold)@@
```
--!>
