#!/bin/bash
#
# extract information from bes log files and prepare them to be read into a spreadsheet

# $1 is the log file name
# $2 is the file name of the cleaned log file

# lines that match: Failed to locate '/usr/share/hyrax/data/catalog.xml' lack a newline at the end
# Same for: CredentialsManager::load_credentials() - CredentialsManager config file /etc/bes/credentials.conf was specified but is not present.

sed -e "s@\(.*|&|info|&|Failed to locate\) \(\'.*\'\)\(.*\)@\1 \2\n\3@g" \
-e "s@\(.*|&|error|&|CredentialsManager::load_credentials() - CredentialsManager config file /etc/bes/credentials.conf was specified but is not present.\)\(.*\)@\1\n\2@g" \
$1
