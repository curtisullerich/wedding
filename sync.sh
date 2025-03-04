# check if we're in the right directory
DIR=$(basename $(pwd))
ULLERICH=$(realpath ../ulleri.ch)
WEDDING=$(realpath .)
if [[ $DIR != wedding ]]; then
  echo "it doesn't look like you're in the root of the wedding repository"
  exit
fi
if [ ! -d $ULLERICH ]; then
  echo "ulleri.ch repository is expected to be a sibling of wedding repository"
  exit
fi
echo "switching to ../ulleri.ch"
cd $ULLERICH
echo "current directory is $(pwd)"
if [[ `git status --porcelain` ]]; then
  echo "ulleri.ch has local changes"
  exit
fi
echo "pulling ulleri.ch"
git pull
echo "switching to ../wedding and running jekyll build"
cd $WEDDING
bundle exec jekyll build
if [[ ! $? ]]; then
  echo "jekyll build had issues"
  exit
fi
read -p "continue by deleting and replacing $ULLERICH/wedding?" -n 1 -r
if [[ ! $REPLY =~ ^[Yy]$ ]]
then
  echo "exiting"
  exit
fi
echo "continuing"
rm -r $ULLERICH/wedding
echo "copying"
cp -r _site/wedding $ULLERICH/
cd $ULLERICH
git add .
git commit -a -m "Published latest changes of /wedding"
read -p "continue by pushing ulleri.ch to github?" -n 1 -r
if [[ ! $REPLY =~ ^[Yy]$ ]]
then
  echo "exiting"
  exit
fi
echo "pushing"
git push
echo "done"
