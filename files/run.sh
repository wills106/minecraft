#!/bin/bash
# Copyright (c) 2020 fithwum
# All rights reserved

:begin

cd /MCserver
java -Xmx4G -Xms1024M -Xmn1G -XX:+UseParNewGC -XX:+UseConcMarkSweepGC -jar ./MCserver.jar nogui

timeout 10

echo resuming server...

goto begin