# Webrun #
Webrun is a library of bash script usefull for repititive web developpement tasks of everyday.

## Module ##
The programm is composed of many modules locate in the folder lib,
a module structure need to meet these conditions :
>  MODULE_FOLDER / runner.sh
> 
>  runner.sh must begin the two following line :
> 
> 		#!/usr/bin/env bash
> 		# Name of your module that will be used in the modules menu
> 


#### buildDoc ####
>  This will automatically build the README.md with all functions name with respective arguments and descriptions.
>  Respect the following convention to have the right output :
> 
>     #@title-(1,2,3...) Title
>     #@intro use it as main description
>     #@name function name
>     #@desc
>     # function description
>     #@desc
>     #args argument label and description separated by : then previous argument group separated by |
>     #@example an example of your function in use

Example : 
>  You can easily generate documentation file as cli command
> 
>      bash webrun.sh -cli documentation {LANGUAGE} {PATH} {DOC_FILE_NAME}
> 
>  Example to generate this documentation file just run
> 
>      bash webrun.sh -cli documentation sh . README
> 


#### Nodejs ####
>  You can do the following action:
>  do a fresh install of node and npm
>  or clean all node component from your environement


#### dump_database ####
| Arguments | Description / Example |
| --------- | --------------------- |
| output file name 
| database name | 
| password | 
| username | 

#### restore_database ####
| Arguments | Description / Example |
| --------- | --------------------- |
| existing dump path  | 
| database name  | | 
| password  | | 
| username  | u | 





## Lib ##
Usefull function used by webrun script and Modules script


### Cli Render Functions ###
These functions will be available in all module executed in cli to render output in a log file
Fill free to add all your tips functions here ;)
#### chk_echo ####
>  Custom echo function, handle state as message prefix

| Arguments | Description / Example |
| --------- | --------------------- |
| separator  | "separator" add a separator at the top 
| state  | error, warning, success | 
| string  | string to echo | 

### Render Functions ###
Render custom output with state color
Fill free to add all your tips functions here ;)
#### chk_echo ####
>  Custom echo function, handle state by color

| Arguments | Description / Example |
| --------- | --------------------- |
| separator  | "separator" add a separator at the top 
| state  | error, warning, success | 
| string  | string to echo | 
#### chk_progressBar ####
| Arguments | Description / Example |
| --------- | --------------------- |
| total steps  | integer 
| current step  | integer | 

