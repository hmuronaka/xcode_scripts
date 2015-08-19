# Scripts for Xcode.

## xcopen
open a xcode project easily.

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

xcopen # if xcopen isn't given any option, user can choose a project from histories.
0: TestProject: ~/xcode_projects/testproject/TestProject.xcworkspace
1: SampleProject: ~/xcode_projects/testproject/SampleProject.xcworkspace
select project >

```
xcopen records history opening the project's path to ~/.xc_history

## xccd

change directory of xcode project.

```sh
xccd SampleProject # move a dictionary of SampleProject. xccd use pushd, not cd. 
```

# Install

git clone this repository
chmod +x install.sh
./install.sh
