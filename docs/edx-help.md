
# Queues 

* To check if xqueue is running:

 `sudo /edx/bin/supervisorctl -c /edx/etc/supervisord.conf status`
 
* To add a queue:

    1. edit /edx/app/xqueue/xqueue.env.json
    2. add a new queue: { "extgrad.zaccaria.com": "http://192.168.1.106:1666" }
    3. or use "http://192.168.33.1:1666"

# xblock 

In the Vagrantfile:

    config.vm.synced_folder "/Users/zaccaria/development/github/xblocks-for-edx", "/edx/xblocks-for-edx", create: true, nfs: true

## To install the component in the Edx virtualenv environment 

Fix configurations appropriately:

    sudo -u edxapp vi /edx/app/edxapp/edx-platform/cms/envs/common.py
    sudo -u edxapp vi /edx/app/edxapp/edx-platform/lms/envs/common.py

Pip install the xblock, e.g.: 

    sudo -u edxapp /edx/bin/pip.edxapp install /edx/xblocks-for-edx/octave

Restart the studio and add your `xblock` to the advanced modules.

## To restart the EDX studio

    sudo /edx/bin/supervisorctl -c /edx/etc/supervisord.conf restart edxapp:

