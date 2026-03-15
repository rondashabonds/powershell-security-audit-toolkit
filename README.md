\# PowerShell Security Audit Toolkit



A PowerShell-based cybersecurity tool that performs a basic Windows system security audit and generates a formatted HTML report. This project demonstrates how PowerShell can be used to automate security monitoring, audit system configurations, and collect important security-related information from Windows endpoints.



\## Project Overview



The PowerShell Security Audit Toolkit scans a Windows system and collects key security information including firewall configuration, antivirus protection status, failed login attempts, open network ports, and important security services. The results are automatically exported into a clean HTML security report for easy analysis.



This project demonstrates practical skills in security automation, Windows endpoint monitoring, system auditing, and PowerShell scripting for cybersecurity.



\## Features



The script performs several important security checks.



It checks Windows Firewall status across all profiles including Domain, Private, and Public networks.



It retrieves Microsoft Defender protection settings such as antivirus status, antispyware protection, real-time protection, and network inspection settings.



It analyzes Windows Security Event Logs to detect failed login attempts using Event ID 4625 from the past seven days. This helps identify possible brute force login attempts or suspicious authentication activity.



It identifies active listening TCP ports on the machine, which can reveal exposed services or potential attack surfaces.



It also verifies that critical Windows security services are running, including Windows Defender, Windows Firewall, and the Windows Event Log service.



\## Example Report Output



The script generates a structured HTML security audit report that contains firewall configuration details, Defender protection status, recent failed login attempts, open listening ports, and security service status. The report is automatically saved with a timestamped filename such as:



security-audit-report-2026-03-15\_17-46-04.html



This makes it easy to keep multiple reports for auditing or monitoring purposes.



\## Technologies Used



PowerShell  

Windows Security Event Logs  

Microsoft Defender PowerShell Module  

Windows Networking Tools  

HTML Report Generation



\## How to Run



1\. Clone the repository:



git clone https://github.com/YOURUSERNAME/powershell-security-audit-toolkit.git



2\. Navigate into the project folder:



cd powershell-security-audit-toolkit



3\. Open PowerShell as Administrator.



4\. Run the script:



Set-ExecutionPolicy RemoteSigned -Scope Process  

.\\SecurityAudit.ps1



5\. After the script finishes running, open the generated HTML report located in the project directory.



\## Example Use Cases



This tool demonstrates techniques used by security engineers, SOC analysts, system administrators, and blue team security teams. Common uses include endpoint security auditing, automated security monitoring, incident response investigation, and reviewing system security configurations.



\## Future Improvements



Future enhancements for this toolkit may include suspicious process detection, risk scoring for vulnerabilities, automatic email alerts for detected issues, IP reputation checks, CSV and JSON report exports, and scheduled security scans.



\## Author



Rondasha Bonds  

Computer Information Systems Student | Cloud and Cybersecurity Enthusiast



\## License



This project is open source and intended for educational and research purposes.

