#!/bin/bash

# NAIVAPT Installer Script
# Script ini digunakan untuk menginstal NAIVAPT beserta dependensinya di Kali Linux

echo -e "\n[+] Menginstal dependensi yang diperlukan...\n"

# Update dan install paket-paket yang dibutuhkan
sudo apt update && sudo apt upgrade -y
sudo apt install -y whois dig sublist3r assetfinder amass curl xsser nikto wpscan commix nmap sqlmap hydra metasploit-framework searchsploit

# Cek apakah git sudah terinstall, jika belum, install git
if ! command -v git &> /dev/null
then
    echo -e "[+] Git tidak ditemukan, menginstal git..."
    sudo apt install git -y
else
    echo -e "[+] Git sudah terinstal"
fi

# Mengunduh repositori ini (bila perlu)
echo -e "\n[+] Mengunduh repositori NAIVAPT..."
git clone https://github.com/na2mikaze/NAIVAPT.git

# Memberi izin eksekusi pada file script
chmod +x NAIVAPT/naivapt.sh

# Memindahkan file ke direktori bin agar bisa dijalankan langsung
sudo mv NAIVAPT/naivapt.sh /usr/local/bin/naivapt

# Memberi petunjuk kepada pengguna
echo -e "\n[+] Instalasi selesai! Anda sekarang bisa menjalankan NAIVAPT dengan perintah 'naivapt'\n"
