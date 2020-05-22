#!/usr/bin/env bash

. config.sh

TARGET_LANG=${BASE_LANG}
TARGET_APP=${DEFAULT_APP}

LOCALE_DIR=${SYSTEM_ROOT}/${TARGET_APP}/Language/Locale/${TARGET_LANG}/LC_MESSAGES
PO_FILE=${LOCALE_DIR}/${SYSNAME}.po
POT_DIR=${SYSTEM_ROOT}/writable/pot/${TARGET_APP}
POT_FILE=${POT_DIR}/{$SYSNAME}/${TARGET_LANG}.pot
LOCAL_PO_FILE=${POT_DIR}/${SYSNAME}/${TARGET_LANG}.po

function run {
  if [ -e ${PO_FILE} ] && [ -e ${POT_FILE} ]; then
    echo 'merged file'
    msgmerge ${PO_FILE} ${POT_FILE} -o ${LOCAL_PO_FILE}
    exit 0
  fi

  if [ -e ${PO_FILE} ] && [ ! -e ${POT_FILE} ]; then
    echo 'copied file'
    cp ${PO_FILE} ${LOCAL_PO_FILE}
    exit 0
  fi

  if [ ! -e ${PO_FILE} ] && [ -e ${POT_FILE} ]; then
    echo 'pot file'
    msginit --no-translator -l ${TARGET_LANG} -i ${POT_FILE} -o ${LOCAL_PO_FILE}
    exit 0
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