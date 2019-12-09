#!/bin/bash

docker-compose exec database pg_dump -U user -s database > schema.sql
