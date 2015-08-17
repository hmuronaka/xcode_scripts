# Scripts for Xcode.

## xcopen
open xcode project.

```sh
# SampleProject is in ~/src/xcode_projects/sampleproject/SampleProject.xcworkspace
cd ~/src
xcopen SampleProject # xcopen search a xcworkspace or xcproject directory recursively

xcopen SampleProject.xcworkspace # open specific xcworkspace or xcproject.

# if multiple same name project is found, can select a project.

xcopen TestProject
0: xcode_projects/testproject/TestProject.xcworkspace
1: temp/testproject/TestProject.xcworkspace
select path > 
```

## xccd

change directory of xcode project.

```sh
xccd SampleProject # use pushd
```

# Install

git clone this repository
chmod +x install.sh
./install.sh
