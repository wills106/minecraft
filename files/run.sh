#!/bin/bash
# Copyright (c) 2018 fithwum
# All rights reserved

cd /MCserver
java -Xmx4G -Xms1024M -Xmn1G -XX:PermSize=512m -XX:+UseParNewGC -XX:+UseConcMarkSweepGC -jar ./MCserver.jar nogui
