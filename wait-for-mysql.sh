#!/bin/bash

until mysqladmin ping -h db --silent; do
  echo "Mysql is unavailable - sleeping"
  sleep 1
done

echo "Mysql is up - executing command"
exec $cmd
