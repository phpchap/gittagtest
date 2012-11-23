#############################
# Bump the current Github tag
#############################
# http://en.wikipedia.org/wiki/Software_versioning

# check we have called the script with valid parameters
if [ ! $# == 1 ]; then
  echo "Usage: '$0 (major|minor|revision)' - increment the github tag according to the release type"
  exit
fi

# fetch the tags from repo in case anyone else is bumping number
echo "fetching the tags from repo..."
git fetch --tags

# what kind of a release is this?
BUMP=$1 

# grab the version numbers from git
MAJOR=`git describe | cut -d "." -f2`
MINOR=`git describe | cut -d "." -f3`
REVISION=`git describe | cut -d "-" -f1 | cut -d "." -f4`

# whats the current version were on
CURRENTVERSION="v."$MAJOR"."$MINOR"."$REVISION

# get the current directory
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# create the release directory if not exists
mkdir -p $DIR/releases/

# display version and bump release (and credit to me!)
echo "------------------------------------------------------------"
echo "Git Versioning Script by: Justen Doherty (phpchap@gmail.com)"
echo "Current Version: "$CURRENTVERSION
echo "-------------------------------------------------------------"
echo "we have a '"$BUMP"' release..."

# depending on the version type, increment the counter
case "$1" in
'major')
echo "increment major release number..."
BUMPED=`expr $MAJOR + 1`
VERSION="v."$BUMPED".0.0"
;;
'minor')
echo "increment minor release number..."
BUMPED=`expr $MINOR + 1`
VERSION="v."$MAJOR"."$BUMPED".0"
;;
'revision')
echo "increment revision release number..."
BUMPED=`expr $REVISION + 1`
VERSION="v."$MAJOR"."$MINOR"."$BUMPED
;;
esac

# pull everything from git first
echo "pulling everything from git first"
git pull origin master

# create a release log
echo "create log of all the comments for the tag ($VERSION) into releases/$VERSION.txt"
git log $CURRENTVERSION..HEAD > $DIR/releases/$VERSION.txt

# add all the git files
echo "adding all files and commiting..."
git add .
git commit -m "$1 release ($VERSION)"

# tag the branch
echo "tagging code with version '$VERSION' and with the following message '$1 release ($VERSION)'"
git tag -a $VERSION -m "$1 release ($VERSION)"

# push all the content back to git
echo "pushing everying to git repo origin master..."
git push origin master

# all done!
echo "all done.."
