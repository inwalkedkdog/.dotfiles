#! /usr/bin/env bash

ROOT_UID=0
TENGB_TPG=zfs-10g-tpg
POOL=data0
VOLNAME=""

if [ "$UID" -ne "$ROOT_UID" ]
then
  echo "Must be root to run this script."
  exit $E_NOTROOT
fi  

case "$1" in
  ""      	) XXX DEFAULTS ;;
  *[!0-9]*	) echo "Usage: `basename $0` hostname volsize iscsi_initiator_id [volname] [poolname]"; exit ;;
  *       	) XXX=$1 YYY=$2;;
esac

HOSTNAME = $1
VOLSIZE = $2
INITIATOR = $3

if [ -e $4 ]
then
  VOLNAME = $4
else
  VOLNAME = $HOSTNAME_vol
fi  

if [ -e $5 ]
then
  POOL = $5
fi  

if [ $INITIATOR ]
then
  exit
fi

# verify volume doesn't exist
zfs list -t volume | grep $VOLNAME

# check if volsize ok


zfs create -s -V $VOLSIZE $POOL/$VOLNAME	# zfs create -s -V 30G corsair/vm0

sbdadm create-lu /dev/zvol/rdsk/$POOL/$VOLNAME

# match the GUID
Created the following LU:

GUID                    DATA SIZE           SOURCE
--------------------------------  -------------------  ----------------
600144f0f6d38f0000004ec455e40001  32212254720          /dev/zvol/rdsk/corsair/vm0

# verify tg does not already exist or reuse existing tg
stmfadm create-tg $HOSTNAME-tg

# match target or reuse existing target
itadm create-target				# "Target XXX successfully created"

# or reuse existing modified target
itadm modify-target -t $TENGB_TPG $TARGET	# "Target XXX successfully modified"

# or reuse existing tg and target
svcadm disable stmf
stmfadm add-tg-member -g $HOSTNAME-tg $TARGET
svcadm enable stmf

stmfadm create-hg aprilia-hg
stmfadm add-hg-member -g $HOSTNAME-hg $INITIATOR

# or reuse existing tg
stmfadm add-view -h $HOSTNAME-hg -t $HOSTNAME-tg $GUID
