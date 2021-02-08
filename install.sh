#!/usr/bin/env bash

APPNAME="ssl"
USER="${SUDO_USER:-${USER}}"
HOME="${USER_HOME:-${HOME}}"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# @Author          : Jason
# @Contact         : casjaysdev@casjay.net
# @File            : install.sh
# @Created         : Fr, Aug 28, 2020, 00:00 EST
# @License         : WTFPL
# @Copyright       : Copyright (c) CasjaysDev
# @Description     : installer script for ssl
#
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Set functions

SCRIPTSFUNCTURL="${SCRIPTSAPPFUNCTURL:-https://github.com/casjay-dotfiles/scripts/raw/master/functions}"
SCRIPTSFUNCTDIR="${SCRIPTSAPPFUNCTDIR:-/usr/local/share/CasjaysDev/scripts}"
SCRIPTSFUNCTFILE="${SCRIPTSAPPFUNCTFILE:-app-installer.bash}"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

if [ -f "$SCRIPTSFUNCTDIR/functions/$SCRIPTSFUNCTFILE" ]; then
  . "$SCRIPTSFUNCTDIR/functions/$SCRIPTSFUNCTFILE"
elif [ -f "$HOME/.local/share/CasjaysDev/functions/$SCRIPTSFUNCTFILE" ]; then
  . "$HOME/.local/share/CasjaysDev/functions/$SCRIPTSFUNCTFILE"
else
  curl -LSs "$SCRIPTSFUNCTURL/$SCRIPTSFUNCTFILE" -o "/tmp/$SCRIPTSFUNCTFILE" || exit 1
  . "/tmp/$SCRIPTSFUNCTFILE"
fi

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
system_installdirs

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Make sure the scripts repo is installed

scripts_check

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Defaults
APPNAME="${APPNAME:-ssl}"
APPDIR="/usr/local/etc/$APPNAME"
INSTDIR="${INSTDIR}"
REPO="${SYSTEMMGRREPO:-https://github.com/systemmgr}/${APPNAME}"
REPORAW="${REPORAW:-$REPO/raw}"
APPVERSION="$(__appversion $REPORAW/master/version.txt)"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# dfmgr_install fontmgr_install systemmgr_install pkmgr_install systemmgr_install thememgr_install wallpapermgr_install

systemmgr_install

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Script options IE: --help

show_optvars "$@"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Requires root - no point in continuing

sudoreq # sudo required
#sudorun  # sudo optional

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# end with a space

APP="openssl "

# install packages - useful for package that have the same name on all oses
install_packages $APP

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Ensure directories exist

ensure_dirs
ensure_perms

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Main progam

if [ -d "$APPDIR" ]; then
  execute "backupapp $APPDIR $APPNAME" "Backing up $APPDIR"
fi

if [ -d "$INSTDIR/.git" ]; then
  execute \
    "git_update $INSTDIR" \
    "Updating $APPNAME configurations"
else
  execute \
    "git_clone $REPO/$APPNAME $INSTDIR" \
    "Installing $APPNAME configurations"
fi

# exit on fail
failexitcode

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# run post install scripts

run_postinst() {
  systemmgr_run_postinst
  mkd /etc/ssl/CA
  rm_rf /etc/ssl/CA/CasjaysDev
  cp_rf "$APPDIR/." /etc/ssl/CA/CasjaysDev
  if [ ! -e /etc/ssl/dhparam ]; then
    cp_rf "$APPDIR/dhparam" /etc/ssl/dhparam
  fi
  if [ -d /usr/local/share/ca-certificates ]; then
    cp_rf "$APPDIR/certs/ca.crt" /usr/local/share/ca-certificates/CasjaysDev.crt
  elif [ -d /etc/pki/ca-trust/source/anchors ]; then
    cp_rf "$APPDIR/certs/ca.crt" /etc/pki/ca-trust/source/anchors/CasjaysDev.crt
  fi
  if [ -f "$(command -v update-ca-trust 2>/dev/null)" ]; then
    devnull update-ca-trust extract && devnull update-ca-trust || true
  elif [ -f "$(command -v update-ca-certificates 2>/dev/null)" ]; then
    devnull update-ca-certificates --fresh && devnull update-ca-certificates || true
  fi
}

execute \
  "run_postinst" \
  "Running post install scripts"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# create version file

systemmgr_install_version

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# exit
run_exit

# end
