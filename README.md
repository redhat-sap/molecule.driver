# Ansible Collection - molecule.driver

Documentation for the collection.

## Managed disks snaphots creation

This collection gives you the capability to create managed disks snapshots.
The snapshots creation is performed invoking the `ACTION=backup` of `molecule side-effect` command.

```bash
ACTION=backup molecule side-effect -s <SCENARIO_NAME>
```

The generate snapshot name is equal to `<managed disk name>_< azure_rm_snapshot_suffix>`.
`azure_rm_snapshot_suffix` default value is `default`.

> **Warning**
> All managed disks snapshots with the default suffix will be automatically **deleted** by the molecule test scenario when runnning `molecule destroy command` (if `azure_destroy.yml` playbook is called).

## How to run molecule tests

To run molecule test, first move in the `tests` direcory and then execute the test scenario
you are interested in.

```bash
>> cd tests
>> molecule test -s <SCENARIO_NAME>
```

`<SCENARIO_NAME>` is equal to the scenario's folder name.

For example

```bash
>> cd tests
>> molecule test -s create-instance
```