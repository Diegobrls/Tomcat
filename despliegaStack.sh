#!/bin/bash

# Nombre de la plantilla yml
plantilla="main.yml"

# Nombre del stack
nombre="nuevoStack"

# Crear el stack
aws cloudformation create-stack --stack-name $nombre --template-body file://$plantilla
