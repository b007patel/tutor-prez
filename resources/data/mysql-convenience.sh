#!/bin/bash

mysql -u root --password=beerbeer < ~/gitrepo/tutor-prez/resources/data/mysql/test_data_schema.sql 
mysql -u root --password=beerbeer < ~/gitrepo/tutor-prez/resources/data/mysql/test_data.sql
