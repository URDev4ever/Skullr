<img width="555" height="536" alt="image (28)" src="https://github.com/user-attachments/assets/5c4cd7b1-31db-4366-99e7-7c16a6f7bdef" />


# **SKULLR – Advanced FFUF Web Scanner v3.3**

**SKULLR** is a fully automated wrapper around **FFUF** designed to enhance web content discovery.
It includes automatic installation, protocol detection, wordlist management, false-positive checks, structured reporting, and subdomain discovery—all in one command.

Made by **URDev**.

---

## **✨ Features**

* **One-command installer** (`./skullr.sh install`)
* **Global command** (`skullr <target>`)
* **Automatic HTTP/HTTPS detection**
* **Status code detection** (200/301/302)
* **False-positive validation**
* **Local SecLists integration**
* **Cleaned and optimized wordlists**
* **Directory, file, and extension fuzzing**
* **Subdomain discovery**
* **Organized report structure per scan**
* **Custom User-Agent**
* **ASCII skull banner because style matters**

---

## **📦 Installation**

```bash
git clone https://github.com/URDev4ever/Skullr.git
chmod +x skullr.sh
./skullr.sh install
```

This will:

* Remove old installations
* Install or verify dependencies (**ffuf**, **SecLists**)
* Create the global command `skullr` in `/usr/local/bin`
* Copy the main script into the system
* Make everything executable

After this, you can run SKULLR from anywhere.

---

## **🚀 Usage**

### **Basic Scan**

```bash
skullr example.com
```

### **Protocol-aware scans**

```bash
skullr https://target.com
skullr http://target.com
```

### **Help banner**

```bash
skullr
```

---

## **📁 Output Structure**

Every scan creates its own timestamped directory:

```
~/scans/<target>_<timestamp>/
│
├── results/        # FFUF output files
├── wordlists/      # Cleaned copies of required lists
├── logs/           # Curl logs, copy logs, protocol detection
└── temp/           # Temp runtime data
```

This ensures organized storage and easy review of multiple targets.

---

## **🧠 How It Works (Technical Overview)**

### **1. Protocol Detection**

SKULLR first tries:

1. `https://target/`
2. `http://target/`

It selects whichever responds with a valid **2xx/3xx** code.

### **2. False-Positive Detection**

It sends several random requests to detect wildcard responses (`200` on non-existent paths).
If detected, SKULLR warns you before fuzzing.

### **3. Wordlist Preparation**

For each essential SecLists file:

* Comments removed
* Empty lines removed
* Length capped for performance
* Licensing noise removed (DirBuster lists)

If a wordlist does not exist locally, SKULLR creates a minimal replacement.

### **4. Subdomain Discovery**

Uses SecLists' `subdomains-top1million-110000.txt`,
or falls back to a built-in minimal list.

### **5. FFUF Runs**

Directory fuzzing, file fuzzing, extension fuzzing, and more.
Results go into `results/`.

---

## **🔧 Requirements**

* **bash**
* **ffuf** (installed automatically on apt/pacman/brew systems)
* **curl**
* **SecLists** (auto-installed on apt)

Works on:

* Debian / Ubuntu / Kali
* Arch / Manjaro
* macOS
* Termux (manual SecLists required)

---

## **📝 Example**

```bash
skullr testphp.vulnweb.com
```

Creates:

```
~/scans/testphp.vulnweb_com_20250101_153300/
```

With all wordlists, logs, and results organized automatically.

---

## **❗ Notes**

* Root privileges are required only for installation (writes to `/usr/local/bin`).
* Scanning without authorization is illegal. Use SKULLR only on systems you own or have explicit permission to test.
* Scan 3/5 it's a MASSIVE scan, consider it will take a long time to test.
* SKULLR is tested primarily on Linux.
  macOS fully supported.
  Termux: use with adjusted paths.

---

made with <3 by URDev
