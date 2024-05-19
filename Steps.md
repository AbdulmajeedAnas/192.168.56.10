Provisioning of the master and slave machines in the vagrant file
![Screenshot (35)](https://github.com/AbdulmajeedAnas/192.168.56.10/assets/159162421/e42a163c-8930-4453-9a44-8232aa778ba0)
Creation of bash script in master node to deploy lamp
In order to execute the Ansibe playbook python had to be downloaded on to the slave node
Copied the Master VM's SSH public key to the slave VM before ansible can be used 
Creation of Ansible playbook to execute the bash script on the slave node and verify that the php application is accessible
![Screenshot (28)](https://github.com/AbdulmajeedAnas/192.168.56.10/assets/159162421/839d1c38-2eed-4dbd-a0d9-6a37945b41f7)
![Screenshot (27)](https://github.com/AbdulmajeedAnas/192.168.56.10/assets/159162421/ca94660f-a7e5-4bd6-8bba-903324c9ebd1)
Creating Cronjob to check server every 12am.
![Screenshot (30)](https://github.com/AbdulmajeedAnas/192.168.56.10/assets/159162421/8c063afb-ccc6-44b1-83a8-3eecef1c3a6b)

