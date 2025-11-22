#!/bin/bash

export SUPERSET_SECRET_KEY=iGqGT3P71UAaJRGkHieQYnShlhKqGe+Z350rqtcDQEVn2tPn9OO8UGbG
export FLASK_APP=superset



superset run -p 8088 --with-threads --reload --debugger
