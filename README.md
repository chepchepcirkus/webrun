# Webrun #
 Webrun is a library of bash script, with a module architecture and an interactive user interface.

>  Configuration :
>    Architecture path is set in the config.cfg file


## Module ##
 The programm is composed of many modules locate in the folder lib.

>  A module structure need to meet this conditions :
> 
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
>     #@intro
>     # use it as main description
>     #@intro
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
> 
>  Create a config file with all informations about your database instance


#### dump_database ####
| Arguments | Description / Example |
| --------- | --------------------- |
 username |  database_username| 
|  password |  database_password| 
|  database name |  database_name| 
|  output file name |  name of dump| 
|  path for output file |  by default create in /tmp| 
|  mysql host |  by default 127.0.0.1| 
|  mysql port |  by default 3306| 

#### restore_database ####
| Arguments | Description / Example |
| --------- | --------------------- |
 username |  database_username| 
|  password |  database_password| 
|  database name |  database_name| 
|  path of file to import |  absolute path| 
|  mysql host |  by default 127.0.0.1| 
|  mysql port |  by default 3306| 


## Node Module ##
>  You can easily manage your node / npm instance
>  Do a fresh install
>  Clean all node component from your environement






## Lib ##
 Usefull bash function library


#### trim ####
>  Remove leading/trailing whitespace characters


### Cli render Functions ###
>  These functions will be available if a flag $chk_cli is set and will render output in a custom file
>  Fill free to add all your tips functions here ;)

#### chk_echo ####
>  Render a message with a prefix fora each different state

| Arguments | Description / Example |
| --------- | --------------------- |
 string |  string to echo| 
|  state |  error, warning, success| 
|  string |  log file path| 

### Render Functions ###
>  Render custom output with state color
>  Fill free to add all your tips functions here ;)

#### chk_echo ####
>  Custom echo function, with color state

| Arguments | Description / Example |
| --------- | --------------------- |
 string |  string to echo| 
|  state |  error, warning, success| 
|  separator |  "separator" add a separator at the top| 
#### chk_echo_empty ####
>  Display an empty line

#### chk_echo_separator ####
>  Display a separator line

#### chk_progressBar ####
>  Display a progress bar
>  Call this function for each step throw a while or a for loop

| Arguments | Description / Example |
| --------- | --------------------- |
 current step |  integer| 
|  total steps |  integer| 

