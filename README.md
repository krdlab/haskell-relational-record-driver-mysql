haskell-relational-record-driver-mysql
====

MySQL driver for haskell-relational-record

## Install

### Prepare

    $ mkdir test-hrr && cd test-hrr
    $ hsenv
    $ source .hsenv/bin/activate

### Install Packages

    $ git clone https://github.com/khibino/haskell-relational-record.git && cd haskell-relational-record
    $ make install

    $ git clone https://github.com/krdlab/hdbc-mysql.git && cd hdbc-mysql
    $ git checkout feature/support-cabal-1.18
    $ cabal install

    $ git clone https://github.com/krdlab/haskell-relational-record-driver-mysql.git && cd haskell-relational-record-driver-mysql
    $ cabal install

## Example

    $ cd haskell-relational-record-driver-mysql/example
    $ mysql -h ${host} -u ${user} -p
    mysql> source setup.sql
    mysql> GRANT ... ON TEST.* TO ${user}@...

    $ cabal build
    $ ./dist/build/example/example


