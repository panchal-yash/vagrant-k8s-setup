#!/bin/bash

for i in {1..3}; do ssh root@192.168.1.10$i "ifconfig enp0s3 down" ; done
