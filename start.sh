#!/bin/bash
set -e
ls 
ls ${HOME}/biodynamo/
ls ${HOME}/biodynamo/bin
source ${HOME}/biodynamo/bin/thisbdm.sh

exec "$@"