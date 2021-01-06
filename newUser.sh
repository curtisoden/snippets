#!/bin/bash

#NOTE: This script requires sudoer rights

#USAGE: sh newUser.sh <username> <password> <primary group> '<another group,<another group>'
#i.e. sh newUser.sh testuser B4dP4$$w0rd users 'wheel,devops'

#single command creates the user and home directory, 
#provides the password in encryted format using openssl, 
#adds user to the primary group (which we assume here already exists),
#and adds the user to a list of secondary groups, comma seperated

sudo useradd -m -g $3 -G $4 -p $(openssl passwd -1 $2) $1

echo 'User $1 added with Password $2 ($1 should really change that - maybe we should force a reset next iteration..)'

#TODO: Add option to provision account from Hashi Vault, or maybe enable LDAPS, Kerberos, via Keycloak or ADFS, or even MFA via Duo