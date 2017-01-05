# Webrun #
Webrun is a library of bash script usefull for repititive web developpement tasks of everyday.

## Module ##
The programm is composed of many modules locate in the folder lib,
a module structure need to meet these conditions :
>  MODULE_FOLDER / runner.sh
> 
>  runner.sh must begin with the two following line :
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


## Mysql module ##
>  You can easly manage your (remote) database dump / restore
>  Create a config file with all informations about your database instance


#### dump_database ####
| Arguments | Description / Example |
| --------- | --------------------- |
| mysql port  | by default 3306 
| mysql host  | by default 127.0.0.1 | 
| path for output file  | by default create in /tmp | 
| output file name  | name of dump | 
| database name  | database_name | 
| password  | database_password | 
| username  | database_username | 

#### restore_database ####
| Arguments | Description / Example |
| --------- | --------------------- |
| mysql port  | by default 3306 
| mysql host  | by default 127.0.0.1 | 
| path of file to import  | absolute path | 
| database name  | database_name | 
| password  | database_password | 
| username  | database_username | 


## Nodejs library management ##
>  You can easily manage your node / npm instance
>  Do a fresh install
>  Clean all node component from your environement




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

