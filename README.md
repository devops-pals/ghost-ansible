# Ghost Ansible Playbook
 Used to install/manage a ghost installation on Ubuntu 20.04.

 The Ghost app and the MariaDB instance are running on docker, started with docker-compose. Traffic is reverse proxied with NGINX, which also provides TLS. Certs are provided by LetsEncrypt through certbot.

# How to use
## Create your inventory
First you must create an inventory. This includes the endpoints to your instances as well as any configuration variables. In this example, we'll use an inventory called `foobar`.

```
inventories
└── foobar
    ├── group_vars
    │   └── ghost.yaml
    └── hosts
```

```ini
# hosts

[ghost]
165.232.152.231                             # our server's IP
```

```yaml
# ghost.yaml

ghost_server_url: ghost.foobar.com          # domain we're using for ghost
certbot_email: foo@bar.com                  # email certbot requires
```

## Run the playbook
**Note: Configure your DNS before running the playbook to make sure LetEncrypt can validate your certificate with an HTTP challenge.**

You can use the `run-playbook.sh` script to run the playbook on your instance:
```
./run-playbook.sh foobar
```

By default, the playbook is run as the user `root`. To change this to a user like `ubuntu`, run:
```
./run-playbook.sh foobar ubuntu
```

You can also run the `ansible-playbook` command manually:
```
ansible-playbook -i inventories/foobar -u ubuntu playbooks/ghost.yaml --ask-become-pass
```

If all works correctly, you should now be able to access your ghost instance from the domain you put in `group_vars/ghost.yaml`.
