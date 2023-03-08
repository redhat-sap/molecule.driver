# Test scenario `backup-restore`

## Description

This test scenario aims to verify if the backup and restore functionalities are working fine.

The scenario first creates an instance according to the specification available in `molecule.yml`.
Then, it creates a file, takes a backup, removes the file, restores and checks that file is available after restore.

## How to run test

```bash
>> cd tests
>> molecule test -s backup-restore
```
