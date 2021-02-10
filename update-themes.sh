#!/bin/bash

cd themes/material-dark || return && git pull origin v2-dark && cd - || return
cd themes/material-light || return && git pull origin v2-light && cd - || return
