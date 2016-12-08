#!/usr/bin/env bash
# Deployment of project

## INIT ##
currentd=$PWD
EXCLUDES=$chepk_libd/synchro/.chepksync_excludedlist

## Init recipe available recipe funcions ##
for i in `ls $chepk_libd/synchro/recipe/*.recipe`; do source $i; done

## Get recipe and check ".recipe" file ##
if [[ -n $chepksync_recipe && -e $chepk_libd/synchro/recipe/$chepksync_recipe.recipe ]]
then 
	echo "Recipe : $chepksync_recipe"
	recipe=$chepksync_recipe
else
	echo "No recipe found, default recipe used..."
	recipe=default
fi

## LAUNCH RECIPE ##
"${recipe%.*}_recipe"
