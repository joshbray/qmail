#!/bin/bash
##############################################################
# Title      :  Q-Mail - Quick Mail Review
# Author     :  Josh Bray [joshbray.net]
# Date       :  2016-01-12
# System     :  CentOS/Exim/Dovecot
# Category   :  System/Email
###############################################################
# Description
#    Provides a brief overview of the mail usage of server.
###############################################################
# Start
clear
# Colors
txtpur=$(tput setaf 5)    # Purple
txtcyn=$(tput setaf 6)    # Cyan
txtrst=$(tput sgr0)	  # Text reset
# Attribution
echo "${txtcyn}========================[${txtrst} ${txtpur}Q-MAIL${txtrst}${txtcyn}]=======================${txtrst}"
echo
# Display Exim Basics
echo "${txtcyn}Exiwhat:${txtrst}"
    exiwhat
echo
echo "${txtcyn}Count in Queue:${txtrst}"
    exim -bpc
echo
echo "${txtcyn}Summary:${txtrst}"
    exim -bp
echo
# Display Account/Script Usage
echo "${txtpur}Unique Emails Sent by:${txtrst}"
sudo cat /var/log/exim_mainlog | grep "A\=dovecot_login" | awk -F"A=dovecot_login:" {'print $2'} | cut -f1 -d' ' | sort | uniq -c | sort -n | awk {'print $1, "unique emails sent by" , $2'}
echo
echo "${txtpur}Location of Scripts Sending Mail:${txtrst}"
sudo cat /var/log/exim_mainlog | grep cwd | grep -v /var/spool | awk -F"cwd=" '{print $2}' | awk '{print $1}' | sort | uniq -c | sort -n
echo
# Run Logs for Two Accounts
read -p "${txtcyn}Run logs for specific user(s)? [y/n]${txtrst}" answer
if [[ $answer = y ]] ; then
echo -n "${txtpur}Enter First Address: ${txtrst}"
read sendaddress
echo -n "${txtpur}Enter Second Address (if none leave blank): ${txtrst}"
read recaddress
sudo cat /var/log/exim_mainlog | grep $sendaddress | grep $recaddress
fi
