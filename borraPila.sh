#!/bin/bash

# Nombre del stack que se va a eliminar
nombre="nuevoStack"

# Eliminar el stack
aws cloudformation delete-stack --stack-name $nombre