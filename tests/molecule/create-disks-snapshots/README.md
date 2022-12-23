# Test scenario `create-disks-snapshots`

## Description

This test scenario aims to verify if the Azure managed disk snapshots have been successfully created.

The scenario first creates an instance according to the specification available in `tests/molecule/create-disks-snapshots/molecule.yml`.
Then, it verifies if the number of managed disks snapshots are equal to the number of the managed disks.
Finally, it delete all the snapshots that have the `default` suffix.

## How to run test

```bash
>> cd tests
>> molecule test -s create-disks-snapshots
```
