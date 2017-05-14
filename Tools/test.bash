#! /bin/bash
set -e errexit
set -o pipefail

PRODUCT=EonilEventualNavigationController
IOS_DEST=id=`instruments -s devices | grep "iPhone" | grep "Simulator" | tail -1 | grep -o "\[.*\]" | tr -d "[]"`
xcodebuild -scheme $PRODUCT -destination "$IOS_DEST" -configuration Debug clean build
xcodebuild -scheme $PRODUCT -destination "$IOS_DEST" -configuration Release clean build


