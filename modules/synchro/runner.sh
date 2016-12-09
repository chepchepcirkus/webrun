#!/usr/bin/env bash
# Deployment of project

## INIT ##
currentd=$PWD
EXCLUDES=$chk_module_d/synchro/.chepksync_excludedlist

## Init recipe available recipe funcions ##
for i in `ls $chk_module_d/synchro/recipe/*.recipe`; do source $i; done

## Get recipe and check ".recipe" file ##
if [[ -n $chepksync_recipe && -e $chk_module_d/synchro/recipe/$chepksync_recipe.recipe ]]
then 
	echo "Recipe : $chepksync_recipe"
	recipe=$chepksync_recipe
else
	echo "No recipe found, default recipe used..."
	recipe=default
fi

## LAUNCH RECIPE ##
"${recipe%.*}_recipe"
