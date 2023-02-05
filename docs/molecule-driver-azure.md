# Molecule-Driver-Azure

## Molecule.yml

### Required parameters platforms

**`name`** - name of the instance. Required. No default value.

**`location`** - Azure region for the instance. Required. No default value.

Location is not required if resource group already exists. In that case all the resources will be created in location of resource group.

Possible values can be listed with following command:

```bash
az account list-locations -o table
```

Example Output:

```bash
DisplayName               Name                 RegionalDisplayName
------------------------  -------------------  -------------------------------------
East US                   eastus               (US) East US
East US 2                 eastus2              (US) East US 2
South Central US          southcentralus       (US) South Central US
West US 2                 westus2              (US) West US 2
West US 3                 westus3              (US) West US 3
Australia East            australiaeast        (Asia Pacific) Australia East
Southeast Asia            southeastasia        (Asia Pacific) Southeast Asia
North Europe              northeurope          (Europe) North Europe
```

Column `Name` represents possible values for `location` parameter.

**`vm_size`**

Size of Azure VM to create.

To list all the possible values for specific region please use command

```bash
az vm list-sizes --location <location> -o table
```

`<location>` - Azure region, see above.

Example output of the command

```bash
MaxDataDiskCount    MemoryInMb    Name                    NumberOfCores    OsDiskSizeInMb    ResourceDiskSizeInMb
------------------  ------------  ----------------------  ---------------  ----------------  ----------------------
2                   512           Standard_B1ls           1                1047552           4096
2                   2048          Standard_B1ms           1                1047552           4096
2                   1024          Standard_B1s            1                1047552           4096
```

**`managed_disk_type`**

OS managed disk storage type. Possible values (from cheapest to more expensive):

* Standard_LRS
* StandardSSD_LRS
* Premium_LRS

**`marketplace_image`**

Dictionary with key-value pairs that define Azure OS image.

```text
    offer: rhel-sap-apps
    publisher: redhat
    sku: 79sapapps-gen2
    version: latest
```

Or in case Azure VM with custom image is requied.

```text
    name: "rhel8.6byos_vhd"
    resource_group: packer
```

NOTE for whatever reason all custom image, VM resource group and VM should be in the same region. Otherwise Azure will fail - could not find custom image.

if custom image is BYOS image - `license_type` parameter is required. See below.

To find all possible key pairs for `marketplace_image` use following command

```bash
az vm image list -o table --all
```

This command takes long time list all images available on Azure. There is also more convenient, but anofficial method <https://az-vm-image.info/>.

Here is advice from Microsoft to shorten the list.

```bash
You are retrieving all the images from server which could take more than a minute. To shorten the wait, provide '--publisher', '--offer' , '--sku' or '--edge-zone'. Partial name search is supported.
```

Example output

```bash
Offer                     Publisher       Sku                        Urn                                                                 Version
------------------------  --------------  -------------------------  ------------------------------------------------------------------  ----------------
RHEL-SAP-APPS             RedHat          79sapapps-gen2             RedHat:RHEL-SAP-APPS:79sapapps-gen2:7.9.2021040902                  7.9.2021040902
RHEL-SAP-APPS             RedHat          79sapapps-gen2             RedHat:RHEL-SAP-APPS:79sapapps-gen2:7.9.2021100402                  7.9.2021100402
RHEL-SAP-APPS             RedHat          7_9                        RedHat:RHEL-SAP-APPS:7_9:7.9.2021040901                             7.9.2021040901
RHEL-SAP-APPS             RedHat          7_9                        RedHat:RHEL-SAP-APPS:7_9:7.9.2021100401                             7.9.2021100401
RHEL-SAP-APPS             RedHat          86sapapps-gen2             RedHat:RHEL-SAP-APPS:86sapapps-gen2:8.6.2022052402                  8.6.2022052402
RHEL-SAP-APPS             RedHat          8_6                        RedHat:RHEL-SAP-APPS:8_6:8.6.2022052401                             8.6.202205240
RHEL-SAP-HA               RedHat          79sapha-gen2               RedHat:RHEL-SAP-HA:79sapha-gen2:7.9.2021051502                      7.9.20210515021
RHEL-SAP-HA               RedHat          79sapha-gen2               RedHat:RHEL-SAP-HA:79sapha-gen2:7.9.2021051502                      7.9.2021051502
RHEL-SAP-HA               RedHat          7_9                        RedHat:RHEL-SAP-HA:7_9:7.9.2021051501                               7.9.2021051501
RHEL-SAP-HA               RedHat          86sapha-gen2               RedHat:RHEL-SAP-HA:86sapha-gen2:8.6.2022052402                      8.6.2022052402
```

Respective column from table above should be used in respective key value pair in `marketplace_image`.

If you do not need specific dated image version, please always use `latest`.

For any additional information please see and other Ansible Azure module documentation.

<https://docs.ansible.com/ansible/latest/collections/azure/azcollection/azure_rm_virtualmachine_module.html>

### Optional parameters

**`resourcegroup_name`**

Azure resource group name. Optional. Default value `molecule`, see `playbooks/azure/defaults/main.yml`.

**`virtualnetwork_name`**

Azure virtual network name. Optional. Default value `molecule-vnet`, see `playbooks/azure/defaults/main.yml`.

**`virtualnetwork_address_prefixes`**

Azure virtual network address prefix. Optional. Default value `10.0.0.0/16`, see `playbooks/azure/defaults/main.yml`.

**`subnet_name`**

Azure virtual network subnet name. Optional. Default value `molecule-subnet`, see `playbooks/azure/defaults/main.yml`.

**`subnet_address_prefix_cidr`**

Azure subnet name address CIDR. Optional. Default value `10.0.0.0/24`, see `playbooks/azure/defaults/main.yml`.

**`ssh_user`**

Admin user, should not be root. Optional. Default value `molecule`, see `playbooks/azure/defaults/main.yml`.

**`zones`**

List of zones where VM might be placed. Optional. Default value `[]` - empty list, VM will not be placed in any availability zone, default value hardcoded in the code.

Example:

```ansible
zones: [1, 2, 3]
```

VM will be placed in any of three zones.

Example:

```ansible
zones: [1]
```

VM will be placed in availability zone 1.

For whatever reason, if VM is placed in availability zone, IP allocation method should be static. See parameter below.

**`public_ip_allocation_method`**

How public IP will be allocated. Optional. Default value `Dynamic`, see `playbooks/azure/defaults/main.yml`.

Possible values:

* Dynamic
* Static
* Disabled

`Disabled` for no public IP. Molecule will not be able to connect instance without public IP. Not recommended to disable public IP for instances.

**`DNS Records Management`**

Only possible if public IP address is provisioned for the instance public_ip_allocation_method='Dynamic' or public_ip_allocation_method='Static'

In case A type DNS record is required for the instance following parameters can be added.

**`dns_relative_name`**

**`dns_zone_name`**

**`dns_zone_resourcegroup_name`**

These parameters are only effective if all are provided.

Public DNS zone should already exists. It will not be created by molecule.

dns_zone_resourcegroup_name is resource group name for the public DNS zone, not for the instance.

Only A record will be created, record will be deleted when instance will be destroyed. When instance deallocated DNS name will not work, because incorrect IP address will be in DNS record.

**`ssh_public_key_path`**

Path to ssh public key, that will be used to connect to the instance. Optional. Default value `~/.ssh/id_rsa.pub`, see `playbooks/azure/defaults/main.yml`.
This key will be uploaded to Azure VM to allow SSH logins. File has to exist.

**`ssh_private_key_path`**

Path to ssh public key, that will be used to connect to the instance. Optional. Default value `~/.ssh/id_rsa`, see `playbooks/azure/defaults/main.yml`.
This key will used locally to connect to Azure VM via SSH. File has to exist.

**`priority`**

Instance priority, possible values: `Spot`, `None`.

`Spot` (pay attention to cases) is for spot instances see <https://azure.microsoft.com/en-us/products/virtual-machines/spot/>. Not all instances can be spot instances.

**`eviction_policy`**

Eviction policy for spot VM. Possible values: `Deallocate`, `Delete`.

See <https://azure.microsoft.com/en-us/products/virtual-machines/spot/>.

**`open_ports`**

List of ports (strings) that will be open on created machine. If not provided default port 22 is used.
If provided, port 22 has to be explicitly mentioned.

Example:

```ansible
  open_ports:
    - "22"
    - "4237"
    - "4239"
```

**`license_type`**

Only required when provisioning custom images with BYOS license.

On-premise license for the image or disk.

Choices:

* "Windows_Server"

* "Windows_Client"

* "RHEL_BYOS"

* "SLES_BYOS"

## Example

Here is an example that includes majority of variables.

```ansible
platforms:
  - name: vm1
    location: northeurope
    resourcegroup_name: molecule
    virtualnetwork_name: molecule-vnet
    virtualnetwork_address_prefixes: 10.0.0.0/16
    subnet_name: default
    zones: [1, 2, 3]
    subnet_address_prefix_cidr: 10.0.0.0/24
    vm_size: Standard_B1s
    ssh_user: molecule
    managed_disk_type: Standard_LRS
    public_ip_allocation_method: Dynamic
    ssh_public_key_path: "~/.ssh/id_rsa.pub"
    ssh_private_key_path: "~/.ssh/id_rsa"
    marketplace_image:
      offer: rhel-sap-apps
      publisher: redhat
      sku: 79sapapps-gen2
      version: "latest"
  - name: vm2
    location: northeurope
    vm_size: Standard_B1s
    managed_disk_type: Standard_LRS
    marketplace_image:
      offer: rhel-sap-apps
      publisher: redhat
      sku: 79sapapps-gen2
      version: "latest"
  - name: vm3
    location: northeurope
    vm_size: Standard_B1s
    managed_disk_type: Standard_LRS
    marketplace_image:
      name: "rhel8.6byos_vhd"
      resource_group: packer
    license_type: "RHEL_BYOS"
```

This will create three virtual machines on Azure with respective parameters.

Please note that for second VM only required parameters are specified.

Third VM is created using custom image, in variable `marketplace_image` custom image name and resource group name (where custom image is located) are provided.

## LICENSE

GPLv3

## Author Information

<https://github.com/kksat>

Project Atmosphere
