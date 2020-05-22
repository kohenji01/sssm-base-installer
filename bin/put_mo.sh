#!/usr/bin/env bash

. config.sh

TARGET_APP=${DEFAULT_APP}
PARENT_DIR=$(cd $(dirname $0);cd ..;pwd)

function run {
  POT_DIR=${SYSTEM_ROOT}/writable/pot/${TARGET_APP}/${SYSNAME}

  if [ -z "${TARGET_LANG+x}" ] ; then
    for item in ${LANGS[@]}; do
      LOCALE_DIR=${SYSTEM_ROOT}/${TARGET_APP}/Language/Locale/${item}/LC_MESSAGES
      [ -f ${POT_DIR}/${item}.mo ] && cp ${POT_DIR}/${item}.mo  ${LOCALE_DIR}/${SYSNAME}.mo
      [ -f ${POT_DIR}/${item}.po ] && cp ${POT_DIR}/${item}.po  ${LOCALE_DIR}/${SYSNAME}.po
    done
  else
    LOCALE_DIR=${SYSTEM_ROOT}/${TARGET_APP}/Language/Locale/${TARGET_LANG}/LC_MESSAGES
    [ -f ${POT_DIR}/${TARGET_LANG}.mo ] && cp ${POT_DIR}/${TARGET_LANG}.mo ${LOCALE_DIR}/${SYSNAME}.mo
    [ -f ${POT_DIR}/${TARGET_LANG}.po ] && cp ${POT_DIR}/${TARGET_LANG}.po ${LOCALE_DIR}/${SYSNAME}.po
    #msgfmt -o ${LOCALE_DIR}/${SYSNAME}.mo ${LOCALE_DIR}/${SYSNAME}.po
  fi
}


function usage {
    cat <<EOF
$(basename ${0}) is a copy mo file tool for ${SYSNAME}

Usage:
    $(basename ${0}) [<options>]

Options:
    --appname, -d     Application Directory (defalut : ${DEFAULT_APP})
    --lang, -l        Target Language (defalut : configed all lunguages)
    --version, -v     print $(basename ${0}) version
    --help, -h        print this
EOF
}

function version {
    printf "$(basename ${0}) version 0.0.1 "
}

while [ $# -gt 0 ];
do
    case ${1} in

        --debug|-D)
            set -x
        ;;

        --appname|-d)
            TARGET_APP=${2}
            shift
        ;;

        --lang|-l)
            TARGET_LANG=${2}
            shift
        ;;

        --help|-h)
            usage
            exit 1
        ;;

        --version|-v)
            version
            exit 1
        ;;


        *)
            printf "[ERROR] Invalid option '${1}'"
            usage
            exit 1
        ;;
    esac
done


run
exit 1