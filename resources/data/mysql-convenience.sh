#!/bin/bash

# change __admin*__ to appropriate values

mysql_script_dir=~/gitrepo/tutor-prez/resources/data/mysql/
pushd ${mysql_script_dir}

mysql -u __adminuser__ --password=__adminpwd__ < ./test_data_schema.sql
mysql -u __adminuser__ --password=__adminpwd__ < ./test_data.sql

popd
