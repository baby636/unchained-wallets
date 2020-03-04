#!/bin/bash
directory=docs
tempDir=_docs
branch=gh-pages

build_command() {
  mkdir $tempDir
  # generate the jsdoc
  npm run docs
  # add nojekyll so github pages builds correctly
  touch "$directory/.nojekyll"
  # move jsdocs into deploying directory
  mv $tempDir/* $directory
  # remove temporary directory
  rm -rf $tempDir
}

echo -e "\033[0;32mDeleting old content...\033[0m"
rm -rf $directory

echo -e "\033[0;32mChecking out $branch....\033[0m"
git worktree add $directory $branch

echo -e "\033[0;32mGenerating docs...\033[0m"
build_command

echo -e "\033[0;32mDeploying $branch branch...\033[0m"
cd $directory &&
  git add --all &&
  git commit -m "Deploy updates" &&
  git push origin $branch

echo -e "\033[0;32mCleaning up...\033[0m"
git worktree remove $directory