# BRBuilder

## Description:
BRbuilder is simple CLI  tool primary designed to start Bitrise build with given prameters as workflow and branch.

## Usage:

### Instalation:

`$ git clone https://github.com/siroroman/brbuilder.git`

`$ swift build -c release`

`$ cd .build/release`

`$ cp -f BRBuilder/usr/local/bin/brbuilder`


### Configuration:
1. Save bitrise token with `$ brbuilder token < bitrise token >`. 
2. Get list of apps associated with your account and copy slug of selected app. `$ brbuilder apps`
3. Set slug with `brbuilder slug < slug >` 

Now you can start your first workflow with:
`$ brbuilder build < workflowID > < branch > -t` 

### Comands:
`$ brbuilder token < bitrise token >` Saves bitrise token to key chain.

`$ brbuilder apps` Returns list of apps for user acount.

`$ brbuilder slug < slug >` Sets selected app. If slug argument is omited, it returns slug of currently selected app

`$ brbuilder user` Returns bitrise account details.

`$ brbuilder workflows < slug >` Returns list of workflows for given app.

`$ brbuilder build < workflowID > < branch >`  Starts workflow on given branch, -t modifier adds tag to latest commit on given branch.  First time  when running with -t modifier , you will be promted to select your project root directory.



