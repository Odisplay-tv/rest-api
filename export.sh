#!/bin/bash

docker-compose exec database pg_dump -U user -s database \
  | sed -E 's///g' \
  | nvim -
