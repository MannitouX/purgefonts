#!/bin/bash
 
# purge-alien-loc.sh - V. 1.0.1
#
# Remove oriental/medio-oriental/african/etc. fonts
#   + Libreoffice localization not of use in IT/GB/USA
#
# Author: Rik - www.riksoft.it
# Licence: LGPL
#
 
 
#--------- CONFIG ------------------------------
 
# localisations to keep (pipe separated)
KEEP="en-gb|en-us|it"
 
#-----------------------------------------------
 
 
 
 
sudo apt update
 
# Remove all oriental/arabic/asian fonts in Debian/Ubuntu/Mint
 
fonts="fonts-kacst fonts-kacst-one fonts-khmeros-core fonts-lklug-sinhala fonts-guru fonts-nanum fonts-noto-cjk"
fonts="$fonts fonts-takao-pgothic fonts-tibetan-machine fonts-guru-extra fonts-lao fonts-sil-padauk fonts-sil-abyssinica"
fonts="$fonts fonts-tlwg-* fonts-lohit-* fonts-beng fonts-beng-extra fonts-gargi fonts-gubbi fonts-gujr fonts-gujr-extra"
fonts="$fonts fonts-kalapi fonts-lohit-gujr fonts-samyak-* fonts-noto-unhinted fonts-noto-hinted fonts-navilu fonts-nakula"
fonts="$fonts fonts-orya-extra fonts-pagul fonts-sahadeva fonts-sarai fonts-smc fonts-telu-extra fonts-wqy-microhei"
fonts="$fonts fonts-hosny-amiri fonts-smc-anjalioldlipi fonts-sil-andika fonts-arphic-ukai fonts-arphic-uming"
fonts="$fonts fonts-sipa-arundina fonts-bpg-georgian fonts-khmeros fonts-smc-chilanka fonts-smc-* fonts-noto-ui-extra"
fonts="$fonts fonts-noto-ui-core fonts-noto-extra fonts-noto-core culmus fonts-ipafont fonts-ipafont-*"
fonts="$fonts fonts-farsiweb fonts-hosny-thabit fonts-ukij-uyghur fonts-yrsa-rasa fonts-sil-scheherazade"
fonts="$fonts fonts-unikurdweb fonts-dzongkha fonts-deva-extra"
 
IFS=' ' read -ra aFonts <<< "$fonts"
 
for font in "${aFonts[@]}"; do
  sudo apt purge -y $font
done
 
 
 
#remove orphans/rubbish
sudo rm -r /usr/share/fonts/opentype/fonts-hosny-amiri \
/usr/share/fonts/truetype/andika \
/usr/share/fonts/truetype/arphic \
/usr/share/fonts/truetype/arundina \
/usr/share/fonts/truetype/fonts-bpg-georgian \
/usr/share/fonts/truetype/khmeros \
/usr/share/fonts/opentype/malayalam \
/usr/share/fonts/truetype/malayalam \
/usr/share/fonts/truetype/malayalam \
/usr/share/fonts/truetype/culmus \
/usr/share/fonts/opentype/ipafont-gothic \
/usr/share/fonts/opentype/ipafont-mincho \
/usr/share/fonts/truetype/farsiweb \
/usr/share/fonts/opentype/fonts-hosny-thabit \
/usr/share/fonts/truetype/fonts-ukij-uyghur \
/usr/share/fonts/truetype/fonts-yrsa-rasa \
/usr/share/fonts/truetype/scheherazade \
/usr/share/fonts/truetype/unikurdweb \
/usr/share/fonts/truetype/dzongkha \
/usr/share/fonts/truetype/fonts-deva-extra
 
 
echo "==== Fixing font cache"
sudo fc-cache -f -v && sudo dpkg-reconfigure fontconfig
 
echo "==== Packages left (each containing multiple fonts)"
sudo dpkg -l fonts\*|grep ^ii|awk '{print $2}'
 
 
 
 
echo
echo "We are going to remove Libreoffice Help in any language except $KEEP"
read -p "Press CTRL+C to interrupt, return to continue."
 
#unfortunately this one-liner cannot be used :-(
#because bash doesn't support lookahead
#sudo apt purge '^libreoffice-help-(?!it|en)[a-z]{2}(-[a-z]{2})?$'
#... so... I'll go this way
#sudo apt purge '^libreoffice-help-[a-z]{2,3}(-[a-z]{2})?$'
#sudo apt install libreoffice-help-en-gb libreoffice-help-en-us libreoffice-help-it
#or more cleaner/secure as follows...
 
list=$(sudo dpkg --get-selections | cut -f1 | grep -E '^libreoffice-help-[a-z]{2,3}(-[a-z]{2})?$')
for pkg in $list; do
	if [[ "$pkg" =~ ^(libreoffice-help-($KEEP))$ ]]; then
		echo "Skipping $pkg"
	else
		sudo apt purge -y "$pkg"
	fi
done
 
 
 
 
echo
echo "We are going to remove Libreoffice locales except $KEEP"
read -p "Press CTRL+C to interrupt, return to continue."
 
#sudo apt remove '^libreoffice-l10n-[a-z]{2,3}(-[a-z]{2})?$'
#sudo apt install libreoffice-l10n-en-gb libreoffice-l10n-it
#Safer as follows...
 
list=$(sudo dpkg --get-selections | cut -f1 | grep -E '^libreoffice-l10n-[a-z]{2,3}(-[a-z]{2})?$')
for pkg in $list; do
	if [[ "$pkg" =~ ^(libreoffice-l10n-($KEEP))$ ]]; then
		echo "Skipping $pkg"
	else
		sudo apt purge -y "$pkg"
	fi
done
 
 
 
 
 
echo
echo "Firefox is bound to Libreoffice locales so apt will"
echo "cope installing the missing locales for Firefox."
echo "We are going to remove them as well, except for $KEEP."
read -p "Press CTRL+C to interrupt, return to continue."
 
#sudo apt remove '^firefox-esr-l10n-[a-z]{2,3}(-[a-z]{2})?$'
#sudo apt install firefox-esr-l10n-en-gb firefox-esr-l10n-it
#Safer as follows...
 
list=$(sudo dpkg --get-selections | cut -f1 | grep -E '^firefox-esr-l10n-[a-z]{2,3}(-[a-z]{2})?$')
for pkg in $list; do
	if [[ "$pkg" =~ ^(firefox-esr-l10n-($KEEP))$ ]]; then
		echo "Skipping $pkg"
	else
		sudo apt purge -y "$pkg"
	fi
done
 
 
 
# This could be implemented as well, leaving only the interested languages...
#task-*-desktop
 
 
sudo apt autoremove
 
read -p "Press any key to close."
