#!/bin/bash

set -e

base_dir=$(pwd)

#####################################################
#### Parse command-line options
#####################################################

name=""
remote=""
destination=""

usage() {
  echo "Usage: $0 [OPTIONS]"
  echo "Options:"
  echo "  -n, --name <name>       Name of the project"
  echo "  -r, --remote <remote>   Remote repository URL"
  echo "  -d, --destination <destination>"
  echo "                          Destination folder"
  echo ""
  echo "Example:"
  echo ""
  echo "$0 --name mycomponent --remote 'https://github.com/myaccount' --destination ~/myproject-parent"
  echo ""
  exit 1
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    -n|--name) shift; name="$1" ;;
    -r|--remote) shift; remote="$1" ;;
    -d|--destination) shift; destination="$1" ;;
    *)
      echo "Unknown option: $1" >&2
      usage
      ;;
  esac
  shift
done

# Validate if required options are provided
if [ -z "$name" ] || [ -z "$destination" ]; then
  usage
  exit 1
fi
## Validate if required options are provided
#if [ -z "$name" ] || [ -z "$remote" ] || [ -z "$destination" ]; then
#  usage=
#  exit 1
#fi


#####################################################
#### Setup GitHub Repositories
#####################################################

echo "Setup parent repository for name with remote $remote in $destination"

#remote_parent="$remote/${name}-parent"
#
#if curl -ILs "$remote_parent" | tac | grep -m1 HTTP | grep 404; then
#  echo "$remote_parent does not exist, goto GitHub and setup $remote_parent as empty repository!"
#  exit 0
#fi

#####################################################
#### Setup parent git repository
#####################################################

echo "Setup git repository"
mkdir -p "$destination"
cd "$destination"
git init
git branch -m main

echo "Setup basic files repository"
echo "# Parent repository for $name" > "$destination/README.md"
echo "0.0.1dev" > "$destination/VERSION"
cp "$base_dir/makefile" makefile
sed -i '.bak' "s/<NAME>/${name}/g" makefile
rm makefile.bak
cp "$base_dir/.gitignore" .gitignore

git add .
git commit -m "Setup repository"


#####################################################
#### Create cltl-requirements in parent repository
#####################################################

echo "Add requirements"
wget https://github.com/leolani/cltl-requirements/archive/main.zip
unzip main.zip
rm main.zip
mv cltl-requirements-main cltl-requirements
echo "# Requirements for $name" > cltl-requirements/README.md
cp "$base_dir/cltl-requirements/requirements.txt" cltl-requirements/requirements.txt
rm -rf cltl-requirements/util
git add .
git commit -m "Add cltl-requirements"


#####################################################
#### Add components as git submodules
#####################################################

echo "Add submodules"
git submodule add -b main https://github.com/leolani/cltl-build.git cltl-requirements/util
git submodule add -b main --name emissor https://github.com/leolani/emissor.git emissor
git submodule add -b main --name util https://github.com/leolani/cltl-build.git util
git submodule add -b main --name cltl-combot https://github.com/leolani/cltl-combot.git cltl-combot
git submodule add -b main --name cltl-emissor-data https://github.com/leolani/cltl-emissor-data.git cltl-emissor-data
git submodule add -b main --name cltl-chat-ui https://github.com/leolani/cltl-chat-ui.git cltl-chat-ui

git submodule update --init --recursive
git add .
git commit -m "Add submodules"


#####################################################
#### Create application repository from template
#####################################################

echo "Add ${name}-app"
wget https://github.com/leolani/cltl-template/archive/main.zip
unzip main.zip
rm main.zip
mv cltl-template-main "${name}-app"

cd "${name}-app"
./init_component.sh -n "${name}-app" --namespace "${name}"
rm -rf util .gitmodules
git add .
git commit -m "Setup application for ${name}"
cd ..
git submodule add -b main https://github.com/leolani/cltl-build.git ${name}-app/util

#####################################################
#### Copy Python application
#####################################################

echo "Setup application in $destination/${name}-app/py-app"
cd "${name}-app"
cp -r "$base_dir/template-app/py-app/app.py" py-app
cp -r "$base_dir/template-app/py-app/config/default.config" py-app/config/default.config
cp "$base_dir/template-app/makefile" makefile
cp "$base_dir/template-app/setup.py" setup.py
cp "$base_dir/template-app/requirements.txt" requirements.txt

cd ..
git add .
git commit -m "Add application"


#####################################################
#### Change component names in makefiles and setup.py
#####################################################

echo "RENAME template-app in makefile and ${name}-app/makefile"
echo "RENAME package name in ${name}-app/setup.py"

cd "${name}-app"
sed -i '.bak' "s/<NAME>/${name}/g" makefile
rm makefile.bak
sed -i '.bak' "s/<NAME>/${name}/g" setup.py
rm setup.py.bak
sed -i '.bak' "s/<NAME>/${name}/g" py-app/app.py
rm py-app/app.py.bak
git add .
git commit -m "Adjust names"
cd ..

#sed -i '.bak' 's/template-app/"${name}"-app/g' makefile
#rm makefile.bak
#git add .
#git commit -m "Adjust names"


#####################################################
#### Setup origin and push
#####################################################

#git remote add origin $remote_parent
echo "Run"
echo ""
echo "git push --set-upstream origin main"
echo ""
echo "to push your changes"