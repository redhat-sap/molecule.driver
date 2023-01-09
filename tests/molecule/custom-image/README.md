# Custom image

This test scenario aims to verify if the Azure instance with custom user image has been successfully and properly created.

The scenario first creates an instance according to the specification available in `tests/molecule/custom-image/molecule.yml`.
Then, It verifies:

- if the Operating System is equal to the one configurated in the `platforms` section of `tests/molecule/create-instance/molecule.yml`
- if the instance name is equal to the requested name
- if the instance belongs to the correct resource group
- if the data disk has been properly created

## How to run test

```bash
>> cd tests
>> molecule test -s custom-image
```
