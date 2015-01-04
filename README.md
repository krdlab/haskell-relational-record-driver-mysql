# MySQL driver for haskell-relational-record

[![Build Status](https://drone.io/github.com/krdlab/haskell-relational-record-driver-mysql/status.png)](https://drone.io/github.com/krdlab/haskell-relational-record-driver-mysql/latest)

*This project was merged into [haskell-relational-record](https://github.com/khibino/haskell-relational-record).*

## Prepare

```sh
$ git clone git@github.com:khibino/haskell-relational-record.git
$ git clone git@github.com:bos/hdbc-mysql.git
$ git clone git@github.com:krdlab/haskell-relational-record-driver-mysql.git
```

```sh
$ cd haskell-relational-record-driver-mysql/example
$ cabal sandbox init
$ cabal sandbox add-source \
    ../../haskell-relational-record/HDBC-session \
    ../../haskell-relational-record/names-th \
    ../../haskell-relational-record/persistable-record \
    ../../haskell-relational-record/relational-query \
    ../../haskell-relational-record/relational-query-HDBC \
    ../../haskell-relational-record/relational-schemas \
    ../../haskell-relational-record/sql-words \
    ../../hdbc-mysql \
    ../
$ cabal install --only-dependencies

$ mysql -h localhost -u root -p < setup.sql
```

## Run example

```sh
$ cd haskell-relational-record-driver-mysql/example
$ cabal build
$ ./dist/build/example/example
[("krdlab",2014-02-01),("bar",2014-02-11)]
[("bar@example.com",2014-02-11)]
```

