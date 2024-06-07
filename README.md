# Packer Proxmox template builder

## Requirements

Create user with required role and create Token:
 
```
pveum user add packer@pve --password packer
pveum aclmod / -user packer@pve -role PVEAdmin
pveum user token add packer@pve packer -expire 0 -privsep 0
```

Set Credentials

```
export PKR_VAR_proxmox_token_id="packer@pve!packer"
export PKR_VAR_proxmox_token_secret="token_secret"
export PKR_VAR_proxmox_url="https://localhost:8006/api2/json"
export PKR_VAR_ssh_username="julien"
export PKR_VAR_ssh_password="julien"
```

