# Scripts for Xcode.

This contains some scripts for Xcode. If you have many Xcode projctes and you are often changing directory for moving Xcode project, you'll be happy.

## xcopen
Open a xcode project easily.

![xo.gif](docs/images/xo.gif)

```sh
# SampleProject is in ~/src/xcode_projects/sampleproject/SampleProject.xcworkspace
cd ~/src
xcopen SampleProject # xcopen search a xcworkspace or xcproject directory recursively

xcopen SampleProject.xcworkspace # open specific xcworkspace or xcproject.

# If multiple same name project is found, can select a project.

xcopen TestProject
0: xcode_projects/testproject/TestProject.xcworkspace
1: temp/testproject/TestProject.xcworkspace
select path > 

xcopen # if xcopen isn't given any project name, xcopen shows history of project name opened, then user can choose a project from history.
0: TestProject: ~/xcode_projects/testproject/TestProject.xcworkspace
1: SampleProject: ~/xcode_projects/testproject/SampleProject.xcworkspace
select project >
```

xcopen records history opening the project's path to ~/.xc_history

## xccd

Change directory of xcode project.

![xc.gif](docs/images/xc.gif)

```sh
xccd SampleProject # move a dictionary of SampleProject. xccd use pushd, not cd. 

xccd # if xccd isn't given project name, xccd shows history of project name opened, then user can choose a project from history. 
 0:   TestProject: ~/xcode_projects/testproject/TestProject.xcworkspace
 1: SampleProject: ~/xcode_projects/testproject/SampleProject.xcworkspace
```

## xclist

Print Xcode projects in search directories

```sh
xclist ~/src 10 # 10 is depth of search-recursively
```

## xcindex

Make index file for xcopen, xccd, xclist


```sh
xcindex ~/src 10 # 10 is depth of search-recursively
```

# Install

git clone this repository
chmod +x install.sh
./install.sh
