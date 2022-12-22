# Test scenario `create-disks-snapshots`

This test scenario aims to verify if the Azure managed disk snapshots have been successfully created.

The scenario first creates an instance according to the specification available in `tests/molecule/create-disks-snapshots/molecule.yml`.
Then, it verifies if the number of managed disks snapshots are equal to the number of the managed disks.
Finally, it delete all the snapshots that have the `_default` suffix.

## Platform details

This test scenario has two platforms: `disks-snap-test1` and `disks-snap-test2`.
- `disks-snap-test1` has two managed disks (`disks-snap-test1_data_disk0` and `disks-snap-test1_data_disk1`).\
It generates two managed disks snapshots: `disks-snap-test1_data_disk0_default` and `disks-snap-test1_data_disk1_default`
- `disks-snap-test2` has one managed disks (`disks-snap-test2_data_disk0`)\
It generate one managed disk snapshot `disks-snap-test2_data_disk0_default`

### How to run test

```bash
>> cd tests
>> molecule test -s create-disks-snapshots
```
