#!/usr/bin/env bash
# ---------------------------------------------------------------------------------------------------|
#  Repo                    : https://github.com/bradyhouse/house_____________________________________|
#  Specification           : N/A_____________________________________________________________________|
#  Specification Path      : N/A_____________________________________________________________________|
#  Author                  : brady house_____________________________________________________________|
#  Create date             : 05/26/2018______________________________________________________________|
#  Description             : MASTER ANGULAR2-CLI UPDATE FUNCTION_____________________________________|
#  Entry Point             : build___________________________________________________________________|
#  Input Parameters        : N/A_____________________________________________________________________|
#  Initial Consumer        : ../fiddle-update.sh_____________________________________________________|
# ---------------------------------------------------------------------------------------------------|
#  Revision History::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::|
# ---------------------------------------------------------------------------------------------------|
# BASELINE VERSION - See CHANGELOG @ 230_update_and_shrinkwrap
# ---------------------------------------------------------------------------------------------------|

function nvmInstall() {
  groupLog "nvmInstall";
  if [[ -d ${NVM_DIR} ]]
  then
    source ${NVM_DIR}/nvm.sh;
    nvm install ${NVM_VERSION};
  else
    exit 3;
  fi
}

function isNcuInstalled() {
  if [[ ! $(which ncu;) ]]
  then
      echo "false";
  else
      echo "true";
  fi
}

function ncuInstall() {
  groupLog "ncuInstall";
  installed=$(isNcuInstalled;);
  if [[ "${installed}" == "false" ]]
  then
    os=$(getOS;);
    ./fiddle.sh "setup" "${OS}" "ncu";
  fi
}

function rmNodeModules() {
  groupLog "rmNodeModules";
  if [[ -d "node_modules" ]]
  then
    rm -rf node_modules;
  fi
}

function rmPackageLock() {
  groupLog "rmPackageLock";
  if [[ -f "package-lock.json" ]]
  then
    rm -rf package-lock.json;
  fi
}

function revertTypeScript() {
  groupLog "revertTypeScript";
  npm uninstall typescript
  npm install "typescript@${NG_TYPESCRIPT_VER}" --save-dev
  if [[ -d "node_modules" ]]
  then
    rm -rf node_modules
  fi
}

function revertNgXbootstrap() {
  groupLog "revertNgXbootstrap";
  if [[ $(grep -q "ngx-bootstrap" "package.json";) ]]
  then
    npm uninstall ngx-bootstrap;
    npm install "ngx-bootstrap@${NG_XBOOTSTRAP_VER}" --save
    if [[ -d "node_modules" ]]
    then
      rm -rf node_modules
    fi
  fi;
}

function revertRxJs() {
  groupLog "revertRxJs";
  npm uninstall rxjs;
  npm install "rxjs@${NG_RXJS_VER}" --save
  if [[ -d "node_modules" ]]
  then
    rm -rf node_modules
  fi
}


function updateAngularCli() {
  groupLog "updateAngularCli";
  ng update @angular/cli;
}

function npmCheckUpdates() {
  groupLog "npmCheckUpdates";
  ncu -u;
}

function catch() {
  case $1 in
      0)  endLog "Update complete.";
          ;;
      *)  endLog "fubar! Something went wrong.";
          ;;
  esac
  return $1
}

function update() {
  groupLog "update";

  if [ "$#" -ne 1 ]
  then
    echo "Incorrect number of arguments";
    echo "Please specify the name of the fiddle";
    exit 59;
  fi

  _fiddleDir=$1;

  if [[ ! -d "${_fiddleDir}" ]]
  then
    echo "\"${_fiddleDir}\" does not exist";
    exit 59
  fi


  # try
  (
    nvmInstall || exit $?;
    ncuInstall || exit $?;
    cd ${_fiddleDir};
    rmNodeModules || exit $?;
    rmPackageLock || exit $?;
    npmCheckUpdates || exit $?;
    revertTypeScript || exit $?;
    # revertNgXbootstrap || exit $?;
    # revertRxJs || exit $?;
    updateAngularCli || exit $?;
  )

  # catch
  rc=$?; catch ${rc};

  #finally
  return ${rc};

}
