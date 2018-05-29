#!/usr/bin/env bash
# ---------------------------------------------------------------------------------------------------|
#  School / Organization   : bradyhouse.io___________________________________________________________|
#  Specification           : N/A_____________________________________________________________________|
#  Specification Path      : N/A_____________________________________________________________________|
#  Author                  : brady house_____________________________________________________________|
#  Create date             : 04/12/2016______________________________________________________________|
#  Description             : MASTER ENVIRONMENT VARIABLE SOURCE______________________________________|
#  Command line Arguments  : N/A_____________________________________________________________________|
# ---------------------------------------------------------------------------------------------------|
#  Revision History::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::|
# ---------------------------------------------------------------------------------------------------|
# Baseline Ver - See CHANGELOG @ 201703100420
# 01/24/2018 - See CHANGELOG @ aurelia-dependencies-update
# 05/26/2018 - See CHANGELOG @ 230_update_and_shrinkwrap
# ---------------------------------------------------------------------------------------------------|

export HOME_ROOT=$(mapHomePath;);
export GITHUB_PUBLISH_REPO="bradyhouse.github.io";
export GITHUB_ROOT="${HOME_ROOT}/github";
export BUILD_NUM="201801240420";
export BASH_PROFILE="${HOME_ROOT}/.bash_profile";
export OS=$(getOS;);
export NVM_VERSION="v8.9.4";
export NG_TYPESCRIPT_VER="2.7.2";
export AUTHOR="bradyhouse@gmail.com";
