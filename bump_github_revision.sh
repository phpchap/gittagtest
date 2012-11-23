#############################
# Bump the current Github tag
#############################
# http://en.wikipedia.org/wiki/Software_versioning

if [ ! $# == 1 ]; then
  echo "Usage: '$0 (major|minor|revision)' - increment the github tag according to the release type"
  exit
fi

echo "fetching the tags from github..."
git fetch --tags

# what kind of a release is this?
BUMP=$1 

# grab the version numbers from git
MAJOR=`git describe | cut -d "." -f2`
MINOR=`git describe | cut -d "." -f3`
REVISION=`git describe | cut -d "-" -f1 | cut -d "." -f4`

# whats the current version were on
CURRENTVERSION="v."$MAJOR"."$MINOR"."$REVISION

echo "-------"
echo "Connecting Travel Version Script"
echo "Current Version: "$CURRENTVERSION
echo "-------"
echo "we have a '"$BUMP"' release..."

# depending on the version type, increment the counter
case "$1" in
'major')
echo "increment major release number..."
BUMPED=`expr $MAJOR + 1`
VERSION="v."$BUMPED"."$MINOR".0"
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

echo "pulling everything from git first"
git pull origin master

echo "pushing all the comments for the tag ($VERSION) into releases/$VERSION.txt"
git log $CURRENTVERSION..HEAD > /mnt/build/connecting_travel/src/releases/$VERSION.txt

echo "adding all files and commiting..."
git add .
git commit -m "$1 release ($VERSION)"

echo "tagging code with version '$VERSION' and with the following message '$1 release ($VERSION)'"
git tag -a $VERSION -m "$1 release ($VERSION)"

echo "pushing everying to github origin master..."
git push origin master

echo "all done.."
