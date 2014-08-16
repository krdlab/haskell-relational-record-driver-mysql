# MySQL driver for haskell-relational-record

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
```

## Run example

```sh
$ mysql -h localhost -u root -p
mysql> source setup.sql
mysql> GRANT ALL PRIVILEGES ON TEST.* TO 'hrr-tester'@'127.0.0.1';

$ cabal build
$ ./dist/build/example/example
[("krdlab",2014-02-01),("bar",2014-02-11)]
[("bar@example.com",2014-02-11)]
```

