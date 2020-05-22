#!/bin/bash

. config.sh

function run() {
  [ ! -d ${POT_DIR} ] && mkdir ${POT_DIR}

  cd ${SYSTEM_ROOT}
  php vendor/smarty-gettext/smarty-gettext/tsmarty2c.php -o ${POT_DIR}/smarty.pot ${DEFAULT_APP}/Views

  find ${APP_DIR} -type d \( -name 'smarty' -o -name 'vendor' \) -prune -o ! -path '*/cache/swm3/admin_menus/build/*' -name '*.php' -type f -print | xargs xgettext --from-code=utf-8 --output=${POT_DIR}/php.pot

  msgcat ${POT_DIR}/smarty.pot ${POT_DIR}/php.pot > ${POT_DIR}/${BASE_LANG}.pot

  rm ${POT_DIR}/smarty.pot
  rm ${POT_DIR}/php.pot

  for item in ${LANGS[@]}; do
      [ -f ${LANGUAGE_DIR}/${item}/LC_MESSAGES/${SYSNAME}.po ] && msgmerge ${LANGUAGE_DIR}/${item}/LC_MESSAGES/${SYSNAME}.po ${POT_DIR}/${SYSNAME}.pot -o ${POT_DIR}/${SYSNAME}.${item}.po

  done

}


function usage {
    cat <<EOF
$(basename ${0}) is a tool for setup ${SYSNAME}

Usage:
    $(basename ${0}) [<options>]

Options:
    --appname, -d     Application Directory (defalut : app)
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
            APP_NAME=${2}
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


APP_DIR=${SYSTEM_ROOT}/${APP_NAME}
POT_DIR=${SYSTEM_ROOT}/writable/pot/${APP_NAME}/${SYSNAME}
LANGUAGE_DIR=${APP_DIR}/Language/Locale

run
