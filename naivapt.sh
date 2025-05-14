#!/bin/bash

green="\e[32m"
cyan="\e[36m"
red="\e[31m"
reset="\e[0m"

echo -e "${cyan}"
echo "███╗   ██╗ █████╗ ██╗██╗   ██╗ █████╗ ██████╗ ████████╗"
echo "████╗  ██║██╔══██╗██║██║   ██║██╔══██╗██╔══██╗╚══██╔══╝"
echo "██╔██╗ ██║███████║██║██║   ██║███████║██████╔╝   ██║"
echo "██║╚██╗██║██╔══██║██║╚██╗ ██╔╝██╔══██║██╔═══╝    ██║"
echo "██║ ╚████║██║  ██║██║ ╚████╔╝ ██║  ██║██║        ██║"
echo "╚═╝  ╚═══╝╚═╝  ╚═╝╚═╝  ╚═══╝  ╚═╝  ╚═╝╚═╝        ╚═╝"
echo -e "${reset}"

echo -e "${yellow}Naivapt - Automated VAPT Framework for Kali Linux${reset}"
echo
echo -e "${red}⚠️  DISCLAIMER:${reset}"
echo -e "${yellow} - Naivapt dibuat untuk tujuan edukasi dan pengujian keamanan pada sistem yang dimiliki atau memiliki izin eksplisit.${reset}"
echo -e "${yellow} - Penggunaan alat ini terhadap sistem tanpa izin adalah ilegal dan melanggar hukum internasional dan nasional.${reset}"
echo -e "${yellow} - Pengguna bertanggung jawab penuh atas segala konsekuensi hukum dan etis dari penggunaan alat ini.${reset}"
echo -e "${yellow} - Kami sebagai pembuat tidak bertanggung jawab atas penyalahgunaan, kerusakan sistem, atau pelanggaran hukum apapun yang timbul dari penggunaan tools ini.${reset}"
echo -e "${yellow}G - unakan dengan bijak, etis, dan hanya untuk sistem yang Anda miliki atau diizinkan untuk diuji.${reset}"
echo

read -p "Ketik 1 untuk Lanjut ke Menu Utama: " lanjut
if [[ $lanjut != 1 ]]; then
    echo -e "${red}[!] Keluar...${reset}"
    exit 0
fi

# Menu utama
echo -e "\n${cyan}=== NAIVAPT - Menu Utama ===${reset}"
echo "1. Reconnaissance"
echo "2. Scanning & Enumeration"
echo "3. Vulnerability Assessment"
echo "4. Exploitation (Penetration Testing)"
read -p "Pilih opsi (1-4): " opsi

read -p "Masukkan nama domain / IP target: " target
timestamp=$(date +"%Y%m%d_%H%M%S")
mkdir -p results

case $opsi in
    1)
        echo -e "\n${green}[+] Menjalankan Reconnaissance...${reset}"
        output="results/${target}_reconnaissance_$timestamp.txt"

        echo -ne "${yellow}Reconnaissance sedang berlangsung"
        spin='-\|/'
        i=0

        (
            {
                echo "============================="
                echo "[+] WHOIS Information by Naivapt"
                echo "============================="
                whois $target 2>/dev/null

                echo -e "\n============================="
                echo "[+] DNS Records (dig) by Naivapt"
                echo "============================="
                dig $target any 2>/dev/null

                echo -e "\n============================="
                echo "[+] NS Records by Naivapt"
                echo "============================="
                dig ns $target 2>/dev/null

                echo -e "\n============================="
                echo "[+] A Record by Naivapt"
                echo "============================="
                dig A $target 2>/dev/null

                echo -e "\n============================="
                echo "[+] MX Records by Naivapt"
                echo "============================="
                dig MX $target 2>/dev/null

                echo -e "\n============================="
                echo "[+] TXT Records by Naivapt"
                echo "============================="
                dig TXT $target 2>/dev/null

                echo -e "\n============================="
                echo "[+] Reverse DNS Lookup by Naivapt"
                echo "============================="
                host $target 2>/dev/null

                echo -e "\n============================="
                echo "[+] NSLookup by Naivapt"
                echo "============================="
                nslookup $target 2>/dev/null

                echo -e "\n============================="
                echo "[+] Subdomain Enumeration - Sublist3r by Naivapt"
                echo "============================="
                sublist3r -d $target 2>/dev/null

                echo -e "\n============================="
                echo "[+] Subdomain Enumeration - Assetfinder by Naivapt"
                echo "============================="
                assetfinder --subs-only $target 2>/dev/null

                echo -e "\n============================="
                echo "[+] Subdomain Enumeration - Amass (passive) by Naivapt"
                echo "============================="
                amass enum -passive -d $target 2>/dev/null

                echo -e "\n============================="
                echo "[+] HTTP Header Info (curl) by Naivapt"
                echo "============================="
                curl -I "http://$target" 2>/dev/null

                echo -e "\n============================="
                echo "[+] DNS Zone Transfer Check by Naivapt"
                echo "============================="
                for ns in $(dig NS $target +short); do
                    echo "Checking NS: $ns"
                    dig @$ns $target AXFR 2>/dev/null
                done

                echo -e "\n============================="
                echo "[+] CDN Check (Cloudflare Detection) by Naivapt"
                echo "============================="
                ip=$(dig +short $target | tail -n1)
                if [[ $ip == 104.* || $ip == 172.64.* || $ip == 198.41.* ]]; then
                    echo "$target mungkin menggunakan Cloudflare/CDN (IP: $ip)"
                else
                    echo "$target kemungkinan tidak menggunakan Cloudflare (IP: $ip)"
                fi
            } > "$output"
        ) &

        pid=$!
        while kill -0 $pid 2>/dev/null; do
            i=$(( (i+1) %4 ))
            printf "\r${yellow}Reconnaissance sedang berlangsung ${spin:$i:1}"
            sleep 0.2
        done

        echo -e "\n${green}[✓] Hasil reconnaissance disimpan di: $output${reset}"
        ;;
    
    2)
        echo -e "\n${green}[+] Menjalankan Scanning & Enumeration...${reset}"
        output="results/${target}_scanning_$timestamp.txt"

        echo -ne "${yellow}Scanning sedang berlangsung"
        spin='-\|/'
        i=0
        (
            {
                echo "========== Basic Port Scan by Naivapt =========="
                nmap -sS -T4 $target

                echo -e "\n========== Service Version Detection by Naivapt =========="
                nmap -sV $target

                echo -e "\n========== Aggressive Scan (OS + Traceroute + Script) by Naivapt =========="
                nmap -A $target

                echo -e "\n========== Full TCP Port Scan by Naivapt =========="
                nmap -p- $target

                echo -e "\n========== Vulnerability Scan with NSE by Naivapt =========="
                nmap --script vuln $target

                echo -e "\n========== SMB Enumeration (jika ada port 445 terbuka) by Naivapt =========="
                nmap --script smb-enum-shares,smb-enum-users -p 445 $target

                echo -e "\n========== HTTP Enumeration (jika ada port 80/443) by Naivapt =========="
                nmap --script http-enum -p 80,443 $target

            } > "$output"
        ) &

        pid=$!
        while kill -0 $pid 2>/dev/null; do
            i=$(( (i+1) %4 ))
            printf "\r${yellow}Scanning sedang berlangsung ${spin:$i:1}"
            sleep 0.2
        done

        echo -e "\n${green}[✓] Hasil scanning & enumeration disimpan di: $output${reset}"
        ;;

    3)
        echo -e "\n${green}[+] Menjalankan Vulnerability Assessment...${reset}"
        output="results/${target}_vulnerabilityassessment_$timestamp.txt"

        echo -ne "${yellow}Assessment sedang berlangsung"
        spin='-\|/'
        i=0

        (
            {
                echo "========== Nmap Vuln Scan by Naivapt =========="
                nmap --script vuln $target

                echo -e "\n========== Nmap CVE Scan by Naivapt =========="
                nmap --script http-vuln-cve2020-3452,http-vuln-cve2017-5638 -p 80,443 $target

                echo -e "\n========== Nmap Additional NSE Scripts by Naivapt =========="
                nmap --script ssl-dh-params,ssl-enum-ciphers,http-headers,http-title -p 443 $target

                echo -e "\n========== Nikto Web Vulnerability Scan by Naivapt =========="
                if command -v nikto >/dev/null 2>&1; then
                    nikto -h http://$target
                else
                    echo "Nikto tidak ditemukan. Lewati bagian ini."
                fi

                echo -e "\n========== Nuclei Scan (jika tersedia) by Naivapt =========="
                if command -v nuclei >/dev/null 2>&1; then
                    nuclei -u http://$target
                else
                    echo "Nuclei tidak ditemukan. Lewati bagian ini."
                fi
            } > "$output"
        ) &

        pid=$!
        while kill -0 $pid 2>/dev/null; do
            i=$(( (i+1) %4 ))
            printf "\r${yellow}Assessment sedang berlangsung ${spin:$i:1}"
            sleep 0.2
        done

        echo -e "\n${green}[✓] Hasil vulnerability assessment disimpan di: $output${reset}"
        ;;

    4)
        echo -e "\n${cyan}=== Pilih Tools Exploitation ===${reset}"
        echo "a. Metasploit Framework"
        echo "b. SQLMap (SQL Injection)"
        echo "c. Hydra (Brute Force Login)"
        echo "d. Burp Suite"
        echo "e. XSSer (Cross Site Scripting)"
        echo "f. Nikto (Web Vulnerability Scanner)"
        echo "g. WPScan (WordPress Scan)"
        echo "h. Commix (Command Injection)"
        echo "i. Nmap Exploit Scripts"
        echo "j. Searchsploit"
        echo "k. Panduan Penggunaan Tools (a-j)"
        read -p "Pilih opsi (a-j): " tool
        output="results/${target}_exploitation_$timestamp.txt"

        spinner() {
            spin='-\|/'
            i=0
            while kill -0 $1 2>/dev/null; do
                i=$(( (i+1) %4 ))
                printf "\r${yellow}Sedang memproses ${spin:$i:1}"
                sleep 0.2
            done
            echo ""
        }

        case $tool in
            a)
                echo -e "${green}[!] Jalankan Metasploit secara manual dengan mengetik: msfconsole${reset}"
                ;;

            b)
                echo -e "${green}[+] Menjalankan SQLMap...${reset}"
                (sqlmap -u "http://$target" --batch --risk=3 --level=5 --random-agent --threads=5 >> "$output") &
                spinner $!
                ;;

            c)
                read -p "Masukkan username: " user
                read -p "Masukkan path wordlist: " wordlist
                (hydra -l $user -P $wordlist $target ssh >> "$output") &
                spinner $!
                ;;

            d)
                echo -e "${green}[!] Jalankan Burp Suite secara manual dari aplikasi GUI.${reset}"
                ;;

            e)
                echo -e "${green}[+] Menjalankan XSSer...${reset}"
                (xsser --url "http://$target" >> "$output") &
                spinner $!
                ;;

            f)
                echo -e "${green}[+] Menjalankan Nikto...${reset}"
                (nikto -h "http://$target" >> "$output") &
                spinner $!
                ;;

            g)
                echo -e "${green}[+] Menjalankan WPScan...${reset}"
                read -p "Masukkan API Token WPScan (kosongkan jika tidak punya): " api
                if [[ -z $api ]]; then
                    (wpscan --url "http://$target" --enumerate u >> "$output") &
                else
                    (wpscan --url "http://$target" --enumerate u --api-token $api >> "$output") &
                fi
                spinner $!
                ;;

            h)
                echo -e "${green}[+] Menjalankan Commix...${reset}"
                (commix --url="http://$target" --batch >> "$output") &
                spinner $!
                ;;

            i)
                echo -e "${green}[+] Menjalankan Nmap Exploit Scripts...${reset}"
                (nmap -p- --script vuln $target >> "$output") &
                spinner $!
                ;;

            j)
                echo -e "${green}[+] Menjalankan Searchsploit...${reset}"
                read -p "Masukkan nama aplikasi / service untuk pencarian exploit: " exploit
                (searchsploit $exploit >> "$output") &
                spinner $!
                ;;

            k)
                echo -e "\n${cyan}=== Panduan Penggunaan Tools Exploitation ===${reset}"
                echo -e "${yellow}[a] Metasploit Framework:${reset}"
                echo "  Jalankan secara manual: msfconsole"
                echo "  Contoh: search exploit apache"

                echo -e "\n${yellow}[b] SQLMap:${reset}"
                echo "  Tujuan: Melakukan SQL Injection pada URL target."
                echo "  Contoh input: http://example.com/vuln.php?id=1"

                echo -e "\n${yellow}[c] Hydra:${reset}"
                echo "  Tujuan: Brute force login SSH atau service lainnya."
                echo "  Contoh username: admin"
                echo "  Contoh wordlist: /NAIVAPT/wordlists/list.txt"
                echo "  Target: example.com (IP/domain yang punya SSH aktif)"

                echo -e "\n${yellow}[d] Burp Suite:${reset}"
                echo "  Jalankan secara manual dari GUI untuk intercept traffic web."
                echo "  Cocok untuk eksplorasi login, form, XSS, dll."

                echo -e "\n${yellow}[e] XSSer:${reset}"
                echo "  Tujuan: Menemukan dan mengeksploitasi XSS (Cross Site Scripting)."
                echo "  Contoh input URL: http://example.com/search.php?q=tes"

                echo -e "\n${yellow}[f] Nikto:${reset}"
                echo "  Tujuan: Scan web untuk kerentanan umum (file, header, config)."
                echo "  Contoh target: http://example.com"

                echo -e "\n${yellow}[g] WPScan:${reset}"
                echo "  Tujuan: Scan situs WordPress untuk user, plugin, theme vulnerable."
                echo "  Contoh target: http://example.com"
                echo "  Token opsional dari: https://wpscan.com/profile/api"

                echo -e "\n${yellow}[h] Commix:${reset}"
                echo "  Tujuan: Mendeteksi dan mengeksploitasi command injection di URL."
                echo "  Contoh input: http://example.com/vuln.php?input=123"

                echo -e "\n${yellow}[i] Nmap Exploit Scripts:${reset}"
                echo "  Tujuan: Scan port dan jalankan NSE (Nmap Scripting Engine)."
                echo "  Contoh target: example.com atau 192.168.1.1"

                echo -e "\n${yellow}[j] Searchsploit:${reset}"
                echo "  Tujuan: Cari eksploit lokal berdasarkan nama aplikasi."
                echo "  Contoh: apache 2.4.49"
                echo "  Output: Daftar eksploit dari Exploit-DB yang relevan."
                ;;

            *)
                echo -e "${red}[!] Pilihan tidak valid.${reset}"
                exit 1
                ;;
        esac

        echo -e "${green}[✓] Hasil exploitation disimpan di: $output${reset}"
        ;;
esac
