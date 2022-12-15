# Ansible Collection - molecule.driver

Documentation for the collection.

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