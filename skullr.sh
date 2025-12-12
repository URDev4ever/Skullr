#!/bin/bash
# SKULLR - FFUF Advanced Web Scanner & Self-Installer v3.3
# Fixed HTTP/HTTPS detection and protocol handling
# Usage:
#   Install: ./skullr.sh install
#   Scan: skullr <target-domain>

# Show banner
show_banner() {
    echo ""
    echo '                      :::!~!!!!!:.'
    echo '                  .xUHWH!! !!?M88WHX:.'
    echo '                .X*#M@$!!  !X!M$$$$$$WWx:.'
    echo '               :!!!!!!?H! :!$!$$$$$$$$$$8X:'
    echo '              !!~  ~:~!! :~!$!#$$$$$$$$$$8X:'
    echo '             :!~::!H!<   ~.U$X!?R$$$$$$$$MM!'
    echo '             ~!~!!!!~~ .:XW$$$U!!?$$$$$$RMM!'
    echo '               !:~~~ .:!M"T#$$$$WX??#MRRMMM!'
    echo '               ~?WuxiW*`   `"#$$$$8!!!!??!!!'
    echo '             :X- M$$$$       `"T#$T~!8$WUXU~'
    echo '            :%`  ~#$$$m:        ~!~ ?$$$$$$'
    echo '          :!`.-   ~T$$$$8xx.  .xWW- ~""##*"'
    echo '.....   -~~:<` !    ~?T#$$@@W@*?$$      /`'
    echo 'W$@@M!!! .!~~ !!     .:XUW$W!~ `"~:    :'
    echo '#"~~`.:x%`!!  !H:   !WM$$$$Ti.: .!WUn+!`    _____ __ ____  ____    __    ____'
    echo ':::~:!!`:X~ .: ?H.!u "$$$B$$$!W:U!T$$M~    / ___// //_/ / / / /   / /   / __ \'
    echo '.~~   :X@!.-~   ?@WTWo("*$$$W$TH$! `       \__ \/ ,< / / / / /   / /   / /_/ /'
    echo 'Wi.~!X$?!-~    : ?$$$B$Wu("**$RM!         ___/ / /| / /_/ / /___/ /___/ _, _/'
    echo '$R@i.~~ !     :   ~$$$$$B$$en:``         /____/_/ |_\____/_____/_____/_/ |_|'
    echo '?MXT@Wx.~    :     ~"##*$$$$M~               Made By URDev | Version 3.3'
    echo ""
}

# Show usage
show_usage() {
    show_banner
    echo "========================================="
    echo "    SKULLR - Advanced FFUF Scanner"
    echo "========================================="
    echo ""
    echo "USAGE:"
    echo "  Install:        ./skullr.sh install"
    echo "  Scan:           skullr <target-domain>"
    echo ""
    echo "EXAMPLES:"
    echo "  ./skullr.sh install             # Install command globally"
    echo "  skullr example.com              # Scan a domain"
    echo "  skullr https://target.com       # Scan with HTTPS"
    echo "  skullr http://target.com        # Scan with HTTP"
    echo ""
    echo "FEATURES:"
    echo "  • Auto HTTP/HTTPS detection"
    echo "  • 200/301/302 status detection"
    echo "  • Local SecLists integration"
    echo "  • False positive detection"
    echo "  • File extension scanning"
    echo "  • Subdomain discovery"
    echo "  • Comprehensive reporting"
    echo "  • Admin panel detection"
    echo ""
}

# Installation function
install_skullr() {
    echo ""
    echo "========================================="
    echo "    SKULLR Installation v3.3"
    echo "========================================="
    echo ""

    echo "[*] Checking for previous installations..."

    # Remove old skullr command if exists
    if [ -f "/usr/local/bin/skullr" ]; then
        echo "  [-] Removing old /usr/local/bin/skullr"
        sudo rm -f /usr/local/bin/skullr
    fi

    # Remove old skullr.sh if exists
    if [ -f "/usr/local/bin/skullr.sh" ]; then
        echo "  [-] Removing old /usr/local/bin/skullr.sh"
        sudo rm -f /usr/local/bin/skullr.sh
    fi

    # Remove old symlinks or aliases
    if [ -L "/usr/bin/skullr" ]; then
        echo "  [-] Removing old symlink /usr/bin/skullr"
        sudo rm -f /usr/bin/skullr
    fi

    # Check if running as root
    if [ "$EUID" -eq 0 ]; then
        echo "[!] Running as root."
    fi

    # Check for ffuf
    if ! command -v ffuf &> /dev/null; then
        echo "[!] ffuf not found!"
        echo "[*] Attempting to install ffuf..."

        if command -v apt &> /dev/null; then
            sudo apt update && sudo apt install -y ffuf
        elif command -v pacman &> /dev/null; then
            sudo pacman -Sy --noconfirm ffuf
        elif command -v brew &> /dev/null; then
            brew install ffuf
        else
            echo "[ERROR] Cannot auto-install ffuf. Please install manually:"
            echo "  sudo apt install ffuf  # Debian/Kali"
            exit 1
        fi
    else
        echo "[✓] ffuf found"
    fi

    # Check for seclists
    if [ ! -d "/usr/share/seclists" ]; then
        echo "[!] SecLists not found. Installing..."
        if command -v apt &> /dev/null; then
            sudo apt install -y seclists
        fi
    else
        echo "[✓] SecLists found"
    fi

    # Install skullr command
    echo "[*] Installing skullr command..."

    # Get the directory of this script
    SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    SCRIPT_NAME="$(basename "${BASH_SOURCE[0]}")"
    SCRIPT_PATH="$SCRIPT_DIR/$SCRIPT_NAME"

    # Create the skullr command wrapper
    sudo tee /usr/local/bin/skullr > /dev/null << 'EOF'
#!/bin/bash
# SKULLR Command Wrapper v3.3

# If no arguments, show usage
if [ $# -eq 0 ]; then
    echo ""
    echo '                      :::!~!!!!!:.'
    echo '                  .xUHWH!! !!?M88WHX:.'
    echo '                .X*#M@$!!  !X!M$$$$$$WWx:.'
    echo '               :!!!!!!?H! :!$!$$$$$$$$$$8X:'
    echo '              !!~  ~:~!! :~!$!#$$$$$$$$$$8X:'
    echo '             :!~::!H!<   ~.U$X!?R$$$$$$$$MM!'
    echo '             ~!~!!!!~~ .:XW$$$U!!?$$$$$$RMM!'
    echo '               !:~~~ .:!M"T#$$$$WX??#MRRMMM!'
    echo '               ~?WuxiW*`   `"#$$$$8!!!!??!!!'
    echo '             :X- M$$$$       `"T#$T~!8$WUXU~'
    echo '            :%`  ~#$$$m:        ~!~ ?$$$$$$'
    echo '          :!`.-   ~T$$$$8xx.  .xWW- ~""##*"'
    echo '.....   -~~:<` !    ~?T#$$@@W@*?$$      /`'
    echo 'W$@@M!!! .!~~ !!     .:XUW$W!~ `"~:    :'
    echo '#"~~`.:x%`!!  !H:   !WM$$$$Ti.: .!WUn+!`    _____ __ ____  ____    __    ____'
    echo ':::~:!!`:X~ .: ?H.!u "$$$B$$$!W:U!T$$M~    / ___// //_/ / / / /   / /   / __ \'
    echo '.~~   :X@!.-~   ?@WTWo("*$$$W$TH$! `       \__ \/ ,< / / / / /   / /   / /_/ /'
    echo 'Wi.~!X$?!-~    : ?$$$B$Wu("**$RM!         ___/ / /| / /_/ / /___/ /___/ _, _/'
    echo '$R@i.~~ !     :   ~$$$$$B$$en:``         /____/_/ |_\____/_____/_____/_/ |_|'
    echo '?MXT@Wx.~    :     ~"##*$$$$M~               Made By URDev | Version 3.3'
    echo ""
    echo "========================================="
    echo "    SKULLR - Advanced FFUF Scanner"
    echo "========================================="
    echo ""
    echo "Usage: skullr <target-domain>"
    echo ""
    echo "Examples:"
    echo "  skullr example.com"
    echo "  skullr https://target.com"
    echo "  skullr http://target.com"
    echo ""
    echo "Run './skullr.sh install' to install/update"
    exit 0
fi

# Execute the scan function
exec /usr/local/bin/skullr.sh scan "$@"
EOF

    # Copy the main script to /usr/local/bin
    echo "[*] Copying main script to /usr/local/bin/skullr.sh..."
    sudo cp "$SCRIPT_PATH" /usr/local/bin/skullr.sh
    sudo chmod +x /usr/local/bin/skullr.sh
    sudo chmod +x /usr/local/bin/skullr

    echo ""
    echo "[✓] Installation complete!"
    echo ""
    echo "Now you can use:"
    echo "  skullr <target-domain>"
    echo ""
    echo "Example: skullr testphp.vulnweb.com"
    echo ""
}

# ============================================================================
# SCAN FUNCTION - Fixed HTTP/HTTPS detection
# ============================================================================
scan_target() {
    local TARGET_INPUT="$1"

    # Configuration
    OUTPUT_BASE_DIR="$HOME/scans"
    FFUF_CMD="ffuf"
    SECLISTS_DIR="/usr/share/seclists"
    USER_AGENT="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36"

    # Check if seclists exists locally
    if [ ! -d "$SECLISTS_DIR" ]; then
        echo "[!] SecLists directory not found at: $SECLISTS_DIR"
        SECLISTS_DIR="/usr/share/wordlists"
    fi

    # Clean and validate input
    TARGET=$(echo "$TARGET_INPUT" | sed 's/^https\?:\/\///' | sed 's/^http\?:\/\///' | sed 's/\/$//')
    SCAN_NAME=$(echo "$TARGET" | sed 's/[^a-zA-Z0-9]/_/g' | head -c 50)
    TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
    SCAN_DIR="${OUTPUT_BASE_DIR}/${SCAN_NAME}_${TIMESTAMP}"

    # Create directory structure
    mkdir -p "${SCAN_DIR}/wordlists"
    mkdir -p "${SCAN_DIR}/results"
    mkdir -p "${SCAN_DIR}/logs"
    mkdir -p "${SCAN_DIR}/temp"

    show_banner
    echo "========================================="
    echo "    SKULLR Advanced Scan v3.3"
    echo "========================================="
    echo ""
    echo "[*] Target: ${TARGET}"
    echo "[*] Output directory: ${SCAN_DIR}"
    echo "========================================="

    # Function to detect protocol (HTTP or HTTPS)
    detect_protocol() {
        echo "[*] Detecting protocol (HTTP/HTTPS)..."

        # Try HTTPS first
        https_response=$(curl -s -o /dev/null -w "%{http_code}" \
            -H "User-Agent: ${USER_AGENT}" \
            --max-time 5 \
            "https://${TARGET}/" 2>/dev/null || echo "000")

        if [[ "$https_response" =~ ^[2-3] ]]; then
            echo "  [✓] HTTPS available (Status: ${https_response})"
            PROTOCOL="https"
            return 0
        fi

        # Try HTTP if HTTPS fails
        http_response=$(curl -s -o /dev/null -w "%{http_code}" \
            -H "User-Agent: ${USER_AGENT}" \
            --max-time 5 \
            "http://${TARGET}/" 2>/dev/null || echo "000")

        if [[ "$http_response" =~ ^[2-3] ]]; then
            echo "  [✓] HTTP available (Status: ${http_response})"
            PROTOCOL="http"
            return 0
        fi

        # If both fail, try without protocol detection (use HTTP as default for testing)
        echo "  [!] Could not detect protocol, using HTTP for testing..."
        PROTOCOL="http"
        return 1
    }

    # Function to check for false positives - FIXED with protocol detection
    detect_false_positives() {
        echo "[*] Detecting false positives..."

        # Test random non-existent paths
        RANDOM_PATHS=("skullr_random_$(date +%s)1" "skullr_random_$(date +%s)2" "skullr_random_$(date +%s)3")

        false_positive_count=0
        for path in "${RANDOM_PATHS[@]}"; do
            response_code=$(curl -s -o /dev/null -w "%{http_code}" \
                -H "User-Agent: ${USER_AGENT}" \
                --max-time 5 \
                "${PROTOCOL}://${TARGET}/${path}" 2>/dev/null || echo "000")

            if [[ "$response_code" == "200" ]]; then
                false_positive_count=$((false_positive_count + 1))
                echo "  [!] False positive detected: /${path} returns 200"
            fi
        done

        if [[ $false_positive_count -ge 2 ]]; then
            echo "  [!] WARNING: Server may return 200 for non-existent paths"
            return 1
        fi
        return 0
    }

    # Function to setup wordlists - FIXED: Clean wordlists properly
    setup_wordlists() {
        echo "[*] Setting up wordlists..."

        # List of essential wordlists with local paths
        declare -A wordlist_paths=(
            ["common.txt"]="${SECLISTS_DIR}/Discovery/Web-Content/common.txt"
            ["dirbuster-medium.txt"]="${SECLISTS_DIR}/Discovery/Web-Content/DirBuster-2007_directory-list-2.3-medium.txt"
            ["raft-medium.txt"]="${SECLISTS_DIR}/Discovery/Web-Content/raft-medium-directories.txt"
            ["big.txt"]="${SECLISTS_DIR}/Discovery/Web-Content/big.txt"
            ["backups.txt"]="${SECLISTS_DIR}/Discovery/Web-Content/Common-DB-Backups.txt"
            ["quickhits.txt"]="${SECLISTS_DIR}/Discovery/Web-Content/quickhits.txt"
            ["raft-large-dirs.txt"]="${SECLISTS_DIR}/Discovery/Web-Content/raft-large-directories.txt"
            ["raft-large-files.txt"]="${SECLISTS_DIR}/Discovery/Web-Content/raft-large-files.txt"
        )

        # Subdomain wordlist
        SUBDOMAIN_LIST="${SECLISTS_DIR}/Discovery/DNS/subdomains-top1million-110000.txt"
        if [ ! -f "$SUBDOMAIN_LIST" ]; then
            SUBDOMAIN_LIST="${SCAN_DIR}/wordlists/subdomains.txt"
            echo "  [+] Creating subdomains list..."
            # Create basic subdomain list
            cat > "$SUBDOMAIN_LIST" << 'EOF'
www
mail
ftp
admin
blog
api
test
dev
stage
prod
EOF
        fi
        cp "$SUBDOMAIN_LIST" "${SCAN_DIR}/wordlists/subdomains.txt" 2>/dev/null

        # Copy each wordlist from local seclists
        for wl in "${!wordlist_paths[@]}"; do
            local local_path="${wordlist_paths[$wl]}"
            local output_path="${SCAN_DIR}/wordlists/${wl}"

            if [ -f "$local_path" ]; then
                echo "  [+] Copying ${wl}..."
                # Clean the wordlist while copying - FIX: Remove comments and empty lines
                grep -v '^#' "$local_path" | grep -v '^$' | head -220000 > "$output_path" 2>>"${SCAN_DIR}/logs/copy.log"
                
                # Clean specific problematic patterns from dirbuster list
                if [ "$wl" == "dirbuster-medium.txt" ]; then
                    echo "  [i] Cleaning dirbuster wordlist..."
                    # Remove license headers and metadata
                    sed -i '/^#/d' "$output_path" 2>/dev/null
                    sed -i '/^$/d' "$output_path" 2>/dev/null
                    sed -i '/^This work/d' "$output_path" 2>/dev/null
                    sed -i '/^Attribution-Share/d' "$output_path" 2>/dev/null
                    sed -i '/^license, visit/d' "$output_path" 2>/dev/null
                    sed -i '/^or send a letter/d' "$output_path" 2>/dev/null
                    sed -i '/^Suite 300/d' "$output_path" 2>/dev/null
                    sed -i '/^Priority ordered/d' "$output_path" 2>/dev/null
                    sed -i '/^Copyright/d' "$output_path" 2>/dev/null
                fi
            else
                echo "  [!] Skipping ${wl} - not found locally"
            fi
        done

        # Create admin-specific wordlist from common patterns
        echo "  [+] Creating admin-specific wordlist..."
        cat > "${SCAN_DIR}/wordlists/admin-specific.txt" << 'EOF'
admin
administrator
login
logout
signin
signout
auth
authentication
dashboard
panel
cp
controlpanel
manager
management
sysadmin
system
backend
backoffice
wp-admin
wp-login
administracion
paneldecontrol
user
users
account
accounts
EOF

        # Create combined wordlist - FIX: Clean properly
        echo "  [+] Creating combined wordlist..."
        # First clean each wordlist
        for wl_file in "${SCAN_DIR}"/wordlists/*.txt; do
            if [ -f "$wl_file" ] && [ "$wl_file" != "${SCAN_DIR}/wordlists/combined.txt" ]; then
                # Clean the file
                sed -i '/^#/d' "$wl_file" 2>/dev/null
                sed -i '/^$/d' "$wl_file" 2>/dev/null
                sed -i '/^This work/d' "$wl_file" 2>/dev/null
                sed -i '/^Attribution-Share/d' "$wl_file" 2>/dev/null
                sed -i '/^Copyright/d' "$wl_file" 2>/dev/null
            fi
        done

        # Now create combined wordlist
        cat "${SCAN_DIR}"/wordlists/*.txt 2>/dev/null | \
            grep -v '^#' | \
            grep -v '^$' | \
            grep -v '^This work' | \
            grep -v '^Attribution-Share' | \
            grep -v '^Copyright' | \
            grep -v '^license, visit' | \
            grep -v '^or send a letter' | \
            grep -v '^Suite 300' | \
            grep -v '^Priority ordered' | \
            sort -u > "${SCAN_DIR}/wordlists/combined.txt" 2>/dev/null

        wordlist_count=$(wc -l < "${SCAN_DIR}/wordlists/combined.txt" 2>/dev/null || echo "0")
        echo "[+] Wordlists ready: ${wordlist_count} total entries"

        # Show wordlist sizes
        echo "  [i] Wordlist sizes:"
        for wl in common.txt dirbuster-medium.txt admin-specific.txt subdomains.txt; do
            if [ -f "${SCAN_DIR}/wordlists/${wl}" ]; then
                count=$(wc -l < "${SCAN_DIR}/wordlists/${wl}" 2>/dev/null || echo "0")
                echo "    ${wl}: ${count} entries"
            fi
        done
    }

    # Main scan function with protocol support - FIXED: Redirect ffuf output
    run_scan() {
        local phase=$1
        local wordlist=$3
        local output_file=$4
        local scan_type=$5  # "dir", "file", "subdomain"

        # Build URL based on scan type
        local url=""
        case $scan_type in
            "dir"|"file")
                url="${PROTOCOL}://${TARGET}/FUZZ"
                ;;
            "subdomain")
                url="${PROTOCOL}://FUZZ.${TARGET}/"
                ;;
        esac

        # For file scans, append .ext in the scan_with_extensions function
        if [[ "$2" == "ext" ]]; then
            # This is handled separately in scan_with_extensions
            return
        fi

        echo "[${phase}] Running ${scan_type} scan..."
        echo "  URL: ${url}"
        echo "  Protocol: ${PROTOCOL}"

        # Check if wordlist exists
        if [ ! -f "${wordlist}" ] || [ ! -s "${wordlist}" ]; then
            echo "  [!] Wordlist not found or empty: ${wordlist}"
            return
        fi

        # Different filters for different scan types
        case $scan_type in
            "dir")
                # Directory scan: allow 200, 301, 302
                # FIX: Redirect all ffuf output to log file, not stdout
                ffuf -u "${url}" \
                    -w "${wordlist}" \
                    -H "User-Agent: ${USER_AGENT}" \
                    -H "Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8" \
                    -t 30 \
                    -rate 40 \
                    -timeout 8 \
                    -fc 404,403,400,500,502,503,429 \
                    -mc 200,301,302 \
                    -recursion \
                    -recursion-depth 2 \
                    -o "${SCAN_DIR}/results/${output_file}" \
                    -of csv \
                    -s >/dev/null 2>>"${SCAN_DIR}/logs/ffuf.log"
                ;;
            "file")
                # File scan: 200 only
                ffuf -u "${url}" \
                    -w "${wordlist}" \
                    -H "User-Agent: ${USER_AGENT}" \
                    -t 20 \
                    -rate 30 \
                    -fc 404,403,400,500 \
                    -mc 200 \
                    -o "${SCAN_DIR}/results/${output_file}" \
                    -of csv \
                    -s >/dev/null 2>>"${SCAN_DIR}/logs/ffuf.log"
                ;;
            "subdomain")
                # Subdomain scan: allow 200, 301, 302, 401
                ffuf -u "${url}" \
                    -w "${wordlist}" \
                    -H "User-Agent: ${USER_AGENT}" \
                    -t 40 \
                    -rate 50 \
                    -timeout 10 \
                    -fc 404,502,503 \
                    -mc 200,301,302,401,403 \
                    -o "${SCAN_DIR}/results/${output_file}" \
                    -of csv \
                    -s >/dev/null 2>>"${SCAN_DIR}/logs/ffuf.log"
                ;;
        esac

        # Count results by status code
        echo "  [✓] Results:"
        if [ -f "${SCAN_DIR}/results/${output_file}" ]; then
            for code in 200 301 302; do
                count=$(grep -c ",${code}," "${SCAN_DIR}/results/${output_file}" 2>/dev/null || echo "0")
                if [ "$count" -gt "0" ] 2>/dev/null; then
                    echo "    Status ${code}: ${count} found"
                fi
            done

            # Show first few findings
            echo "  [i] Sample findings:"
            grep -E ",(200|301|302)," "${SCAN_DIR}/results/${output_file}" 2>/dev/null | \
                head -3 | cut -d',' -f1,2 | sed 's/,/ -> /g' | while read line; do
                echo "    $line"
            done
        else
            echo "    No results found"
        fi
    }

    # Enhanced file extension scan with protocol support
    scan_with_extensions() {
        local phase=$1
        local wordlist=$3
        local output_prefix=$4

        echo "[${phase}] Scanning with extensions..."

        # Check if wordlist exists
        if [ ! -f "${wordlist}" ] || [ ! -s "${wordlist}" ]; then
            echo "  [!] Wordlist not found or empty: ${wordlist}"
            return
        fi

        # Common web extensions from seclists
        extensions=("php" "html" "htm" "js" "json" "txt" "xml" "pdf" "zip" "sql" "bak" "old" "tar" "gz" "log" "conf" "config" "ini" "env" "asp" "aspx" "jsp")

        # Use smaller wordlist for extensions
        head -500 "${wordlist}" > "${SCAN_DIR}/temp/extensions_wordlist.txt" 2>/dev/null

        for ext in "${extensions[@]}"; do
            ffuf -u "${PROTOCOL}://${TARGET}/FUZZ.${ext}" \
                -w "${SCAN_DIR}/temp/extensions_wordlist.txt" \
                -H "User-Agent: ${USER_AGENT}" \
                -t 15 \
                -rate 20 \
                -fc 404,403,400,500 \
                -mc 200 \
                -o "${SCAN_DIR}/results/${output_prefix}_${ext}.csv" \
                -of csv \
                -s >/dev/null 2>>"${SCAN_DIR}/logs/extensions.log" &
        done
        wait
        echo "  [✓] Extension scan completed (${#extensions[@]} extensions tested)"
    }

    # Subdomain discovery with protocol support
    scan_subdomains() {
        local phase=$1
        local output_file=$2

        echo "[${phase}] Discovering subdomains..."

        if [ ! -f "${SCAN_DIR}/wordlists/subdomains.txt" ] || [ ! -s "${SCAN_DIR}/wordlists/subdomains.txt" ]; then
            echo "  [!] Subdomain wordlist not found"
            return
        fi

        # Use smaller subset for faster scanning
        head -1000 "${SCAN_DIR}/wordlists/subdomains.txt" > "${SCAN_DIR}/temp/subdomains_small.txt" 2>/dev/null

        ffuf -u "${PROTOCOL}://FUZZ.${TARGET}/" \
            -w "${SCAN_DIR}/temp/subdomains_small.txt" \
            -H "User-Agent: ${USER_AGENT}" \
            -t 40 \
            -rate 50 \
            -timeout 10 \
            -fc 404,502,503 \
            -mc 200,301,302,401,403 \
            -o "${SCAN_DIR}/results/${output_file}" \
            -of csv \
            -s >/dev/null 2>>"${SCAN_DIR}/logs/subdomains.log"

        if [ -f "${SCAN_DIR}/results/${output_file}" ]; then
            # FIX: Safe counting
            count=$(grep -c ",200," "${SCAN_DIR}/results/${output_file}" 2>/dev/null || echo "0")
            redirect_count=$(grep -c ",30[12]," "${SCAN_DIR}/results/${output_file}" 2>/dev/null || echo "0")
            
            # Convert to numbers
            count=${count:-0}
            redirect_count=${redirect_count:-0}
            
            echo "  [✓] Subdomains found: ${count} active, ${redirect_count} redirects"

            if [ "$count" -gt "0" ] 2>/dev/null; then
                echo "  [i] Active subdomains:"
                grep ",200," "${SCAN_DIR}/results/${output_file}" 2>/dev/null | cut -d',' -f1 | head -3 | while read sub; do
                    echo "    ${PROTOCOL}://${sub}.${TARGET}/"
                done
            fi
        else
            echo "  [!] No subdomain results found"
        fi
    }

    # Generate enhanced report with protocol info
    generate_report() {
        echo "[REPORT] Generating detailed report..."

        local report_file="${SCAN_DIR}/SKULLR_REPORT.md"

        cat > "$report_file" << EOF
# SKULLR Advanced Scan Report: ${TARGET}
**Date:** $(date)
**Scan directory:** ${SCAN_DIR}
**Scanner version:** 3.3
**Protocol used:** ${PROTOCOL}
**SecLists source:** ${SECLISTS_DIR}

---

## Executive Summary

EOF

        # Count totals - FIXED: Handle empty grep results properly
        total_200=0
        total_301=0
        total_302=0

        for result_file in "${SCAN_DIR}"/results/*.csv; do
            if [ -f "$result_file" ] && [ -s "$result_file" ]; then
                # Use safe counting that handles empty results
                count_200=$(grep -c ",200," "$result_file" 2>/dev/null)
                count_301=$(grep -c ",301," "$result_file" 2>/dev/null)
                count_302=$(grep -c ",302," "$result_file" 2>/dev/null)
                
                # Convert empty to zero
                [ -z "$count_200" ] && count_200=0
                [ -z "$count_301" ] && count_301=0
                [ -z "$count_302" ] && count_302=0
                
                total_200=$((total_200 + count_200))
                total_301=$((total_301 + count_301))
                total_302=$((total_302 + count_302))
            fi
        done

        cat >> "$report_file" << EOF
- **Active URLs (200):** ${total_200}
- **Permanent Redirects (301):** ${total_301}
- **Temporary Redirects (302):** ${total_302}
- **Total Findings:** $((total_200 + total_301 + total_302))
- **Protocol:** ${PROTOCOL}

---

## Active URLs (Status 200)

EOF

        # Check if we have any results at all
        result_files_found=0
        for result_file in "${SCAN_DIR}"/results/*.csv; do
            if [ -f "$result_file" ] && [ -s "$result_file" ]; then
                result_files_found=1
                break
            fi
        done

        if [ $result_files_found -eq 0 ]; then
            cat >> "$report_file" << EOF
No active URLs (status 200) were found during the scan.

EOF
        else
            for result_file in "${SCAN_DIR}"/results/*.csv; do
                if [ -f "$result_file" ] && [ -s "$result_file" ]; then
                    if grep -q ",200," "$result_file" 2>/dev/null; then
                        filename=$(basename "$result_file")
                        result_count=$(grep -c ",200," "$result_file" 2>/dev/null || echo "0")
                        cat >> "$report_file" << EOF
### ${filename} (${result_count} results)

| URL | Size |
|-----|------|
EOF

                        grep ",200," "$result_file" 2>/dev/null | head -10 | while IFS=',' read -r url status size words lines rest; do
                            echo "| \`${url}\` | ${size} |" >> "$report_file"
                        done

                        if [ "$result_count" -gt "0" ] 2>/dev/null && [ "$result_count" -gt 10 ]; then
                            echo "| ... and $((result_count - 10)) more | ... |" >> "$report_file"
                        fi
                        echo "" >> "$report_file"
                    fi
                fi
            done
        fi

        cat >> "$report_file" << EOF
---

## Critical Findings

EOF

        # Enhanced critical patterns
        critical_patterns=(
            "admin" "login" "wp-admin" "dashboard" "config" "backup" "sql" "db"
            "password" "auth" "token" "secret" "key" "credential" "\.bak$"
            "\.sql$" "\.env" "config\.php" "\.git" "\.htaccess" "phpmyadmin"
        )

        found_critical=0
        for pattern in "${critical_patterns[@]}"; do
            results=$(grep -i -E ",(200|30[12])," "${SCAN_DIR}"/results/*.csv 2>/dev/null | \
                grep -i "$pattern" | \
                cut -d',' -f1,2 | \
                sort -u)

            if [ -n "$results" ]; then
                echo "**Pattern: \`${pattern}\`**" >> "$report_file"
                echo "" >> "$report_file"
                echo "$results" | while IFS=',' read -r file url; do
                    filename=$(basename "$file")
                    echo "- \`${url}\` (in ${filename})" >> "$report_file"
                    found_critical=1
                done
                echo "" >> "$report_file"
            fi
        done

        if [ "$found_critical" -eq 0 ]; then
            echo "No more critical findings detected." >> "$report_file"
            echo "" >> "$report_file"
        fi

        # Check false positives for report
        detect_false_positives >/dev/null 2>&1
        false_positive_result=$?

        cat >> "$report_file" << EOF
---

## Scan Configuration

\`\`\`bash
# Main directory scan (with redirects)
ffuf -u "${PROTOCOL}://${TARGET}/FUZZ" \\
  -w ${SCAN_DIR}/wordlists/combined.txt \\
  -H "User-Agent: ${USER_AGENT}" \\
  -mc 200,301,302 \\
  -fc 404,403,400,500,502,503,429 \\
  -recursion -recursion-depth 2

# Subdomain scan
ffuf -u "${PROTOCOL}://FUZZ.${TARGET}/" \\
  -w ${SCAN_DIR}/wordlists/subdomains.txt \\
  -mc 200,301,302,401,403
\`\`\`

---

## Generated Files

\`\`\`
$(find "${SCAN_DIR}" -type f \( -name "*.csv" -o -name "*.log" -o -name "*.md" \) 2>/dev/null | sort)
\`\`\`

---

*Report generated by SKULLR Scanner v3.3*
*Protocol detected: ${PROTOCOL}*
*False positive detection: $(if [ $false_positive_result -eq 1 ]; then echo "Warning - Possible false positives detected"; else echo "Passed"; fi)*
EOF

        echo "[✓] Report generated: ${report_file}"
    }

    # Main scan execution
    if ! command -v ffuf &> /dev/null; then
        echo "[ERROR] ffuf not found. Run: ./skullr.sh install"
        exit 1
    fi

    # Detect protocol first
    if ! detect_protocol; then
        echo "[!] Could not connect to target. Trying HTTP anyway..."
    fi

    # False positive detection (with proper protocol)
    detect_false_positives

    # Setup wordlists from local seclists
    setup_wordlists

    echo ""
    echo "[*] Starting comprehensive scan..."
    echo "========================================="

    # 1. Quick scan with common.txt
    run_scan "1/5" "" \
        "${SCAN_DIR}/wordlists/common.txt" \
        "01_quick_scan.csv" \
        "dir"

    # 2. Medium scan with dirbuster list
    run_scan "2/5" "" \
        "${SCAN_DIR}/wordlists/dirbuster-medium.txt" \
        "02_medium_scan.csv" \
        "dir"

    # 3. File extension scan
    scan_with_extensions "3/5" "" \
        "${SCAN_DIR}/wordlists/common.txt" \
        "03_files"

    # 4. Admin panel scan
    run_scan "4/5" "" \
        "${SCAN_DIR}/wordlists/admin-specific.txt" \
        "04_admin_scan.csv" \
        "dir"

    # 5. Subdomain discovery (optional)
    echo ""
    read -p "Scan for subdomains? (y/n, default: n): " -n 1 -r
    echo ""
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        scan_subdomains "5/5" "05_subdomains.csv"
    else
        echo "[*] Skipping subdomain scan"
    fi

    # Generate report
    generate_report

# Summary
    echo ""
    echo "========================================="
    echo "    SCAN COMPLETED - SKULLR v3.3"
    echo "========================================="
    echo ""
    echo "ADVANCED FEATURES:"
    echo "  1. ✓ Auto HTTP/HTTPS detection: ${PROTOCOL}"
    echo "  2. ✓ 200/301/302 detection"
    echo "  3. ✓ Local SecLists: ${SECLISTS_DIR}"
    echo "  4. ✓ Admin-specific wordlists"
    echo "  5. ✓ File extension scanning"
    echo "  6. ✓ Subdomain discovery"
    echo "  7. ✓ False positive detection"
    echo ""
    echo "Output directory: ${SCAN_DIR}"
    echo "Main report: ${SCAN_DIR}/SKULLR_REPORT.md"
    echo ""
    echo "Results summary:"

    # Initialize counters - FIXED: Safe counting
    status_200=0
    status_301=0
    status_302=0

    for result_file in "${SCAN_DIR}"/results/*.csv; do
        if [ -f "$result_file" ]; then
            count_200=$(grep -c ",200," "$result_file" 2>/dev/null || echo "0")
            count_301=$(grep -c ",301," "$result_file" 2>/dev/null || echo "0")
            count_302=$(grep -c ",302," "$result_file" 2>/dev/null || echo "0")
            
            # Ensure they're numbers
            count_200=${count_200:-0}
            count_301=${count_301:-0}
            count_302=${count_302:-0}
            
            status_200=$((status_200 + count_200))
            status_301=$((status_301 + count_301))
            status_302=$((status_302 + count_302))
        fi
    done

    echo "  Status 200: ${status_200} found"
    echo "  Status 301: ${status_301} found"
    echo "  Status 302: ${status_302} found"
    echo "  Protocol used: ${PROTOCOL}"

    echo ""
    echo "To view report: cat ${SCAN_DIR}/SKULLR_REPORT.md"
    echo "To delete scan data: rm -rf ${SCAN_DIR}"
    echo ""
}

# ============================================================================
# MAIN ENTRY POINT
# ============================================================================
main() {
    case "$1" in
        "install")
            install_skullr
            ;;
        "scan")
            if [ -z "$2" ]; then
                echo "[ERROR] No target specified"
                echo "Usage: skullr <target-domain>"
                exit 1
            fi
            scan_target "$2"
            ;;
        "")
            show_usage
            ;;
        *)
            # If called directly with argument (e.g., ./skullr.sh example.com)
            # Check if installed
            if [ -f "/usr/local/bin/skullr.sh" ]; then
                # Already installed, run scan
                scan_target "$1"
            else
                # Not installed, show usage
                show_usage
                echo ""
                echo "[!] SKULLR is not installed."
                echo "Run: ./skullr.sh install"
            fi
            ;;
    esac
}

# Run main function
trap 'echo -e "\n[!] Interrupted"; exit 1' INT TERM
main "$@"
