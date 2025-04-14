# 🖥️ Linux Server System Report Script

This Bash script generates a comprehensive system health and status report for a Linux server and emails the results. It includes checks for internet connectivity, network interfaces, system resource usage, temperatures, disk and memory status, failed login attempts, and more.

## 📋 Features

- 📡 **Internet Connectivity** check via `ping`
- 🔌 **Network Interface Status** (Wi-Fi, Docker)
- 📊 **Bandwidth Monitoring** using `ifstat`
- 🌡️ **Temperature Monitoring** via `sensors`
- 🧠 **CPU & Memory Usage** summaries
- 💾 **Disk Usage** on selected partitions
- ⚙️ **Top 5 CPU and Memory Processes**
- ⏳ **Server Uptime** and Load Average
- 📦 **Inode Usage** warning if above 10%
- 👥 **Logged-in Users**
- 🚫 **Failed SSH Login Attempts**
- 📧 **Email Report** sent using `mutt`

## 🛠️ Requirements

Make sure the following tools are installed:

- `mutt`
- `sensors` (usually provided by `lm-sensors`)
- `ifstat`
- `awk`, `grep`, `ps`, `df`, `free`, `uptime`, `who`, `journalctl`, etc. (typically included in most Linux distros)

Install missing tools using your package manager. For example, on Ubuntu/Debian:

```bash
sudo apt install mutt lm-sensors sysstat ifstat
```

Don't forget to configure your `.muttrc` file properly for email delivery.

## 🔧 Configuration

Update the following variable in the script to your desired recipient:

```bash
TO_EMAIL="youremail@hotmail.com"
```

Ensure your network interface names (`enp3s0`, `docker0`) match your system's configuration.

## 🚀 Usage

Make the script executable:

```bash
chmod +x system_report.sh
```

Then run the script:

```bash
./system_report.sh
```

The script will collect system data and email a detailed report to the specified recipient.

## 📤 Email Example Output

```
=================================
Live Server Stats Report
=================================
Generated on: Mon Apr142025,11:45:02
=================================

Internet Status: Available.

Interface Status:
enp3s0:<UP> 
docker0:<UP>

Bandwidth on main interface:
<Output from ifstat>

System Temp: +45.0°C
CPU Temperature: +65.0°C
SSD Temp1: +35.0°C
SSD Temp2: +36.0°C

CPU Usage: 12.5%
...

Failed Login Attempts:
Timestamp: Apr 09 03:12:44
Username: root
IP Address: 192.168.1.100
..........................
```

## 📌 Notes

- Run this script as a cron job to get regular health reports.
- Customize filesystem filters in the `df` command and tune temperature sensors to match your hardware.

## 📜 License

This script is provided as-is with no warranty. Feel free to modify and share it under the MIT License.

---

Let me know if you'd like a version of this README saved to a file or want help turning this into a cron job!
