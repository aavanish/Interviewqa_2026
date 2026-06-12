#!/bin/bash

grep "ERROR" /var/log/app.log | tail -20
