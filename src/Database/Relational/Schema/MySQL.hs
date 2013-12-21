{-# LANGUAGE TemplateHaskell #-}

module Database.Relational.Schema.MySQL
    ( normalizeColumn
    , notNull
    , getType
    , columnsQuerySQL
    , primaryKeyQuerySQL
    )
    where

import           Data.Int               (Int16, Int32, Int64)
import           Data.Char              (toLower, toUpper)
import           Data.Map               (Map, fromList)
import qualified Data.Map               as Map
import           Data.Time              (LocalTime, Day)
import           Language.Haskell.TH    (TypeQ)
import           Control.Applicative    ((<|>))

import Database.Relational.Query        ( Query
                                        , query
                                        , relation'
                                        , wheres
                                        , (.=.)
                                        , (!)
                                        , (><)
                                        , placeholder
                                        , asc
                                        , value
                                        )
import Database.Relational.Query.Type   (relationalQuery)

import           Database.Relational.Schema.MySQLInfo.Columns           (Columns, columns)
import qualified Database.Relational.Schema.MySQLInfo.Columns           as Columns
import           Database.Relational.Schema.MySQLInfo.TableConstraints  (tableConstraints)
import qualified Database.Relational.Schema.MySQLInfo.TableConstraints  as Tabconst
import           Database.Relational.Schema.MySQLInfo.KeyColumnUsage    (keyColumnUsage)
import qualified Database.Relational.Schema.MySQLInfo.KeyColumnUsage    as Keycoluse

mapFromSqlDefault :: Map String TypeQ
mapFromSqlDefault = fromList
    [ ("VARCHAR",   [t|String|])
    , ("TEXT",      [t|String|])
    , ("CHAR",      [t|String|])
    , ("CHARACTER", [t|String|])
    , ("TIMESTAMP", [t|LocalTime|])
    , ("DATE",      [t|Day|])
    , ("SMALLINT",  [t|Int16|])
    , ("INTEGER",   [t|Int32|])
    , ("BIGINT",    [t|Int64|])
    , ("BLOB",      [t|String|])
    , ("CLOB",      [t|String|])
    ]

normalizeColumn :: String -> String
normalizeColumn =  map toLower

notNull :: Columns -> Bool
notNull =  (== "NO") . Columns.isNullable

getType :: Map String TypeQ
        -> Columns
        -> Maybe (String, TypeQ)
getType mapFromSql rec = do
    typ <- Map.lookup key mapFromSql
           <|>
           Map.lookup key mapFromSqlDefault
    return (normalizeColumn $ Columns.columnName rec, mayNull typ)
    where
        key = map toUpper $ Columns.dataType rec
        mayNull typ = if notNull rec
                      then typ
                      else [t|Maybe $(typ)|]

columnsQuerySQL :: Query (String, String) Columns
columnsQuerySQL =  relationalQuery columnsRelationFromTable
    where
        columnsRelationFromTable =  relation' $ do
            c <- query columns
            (schemaP, ()) <- placeholder (\ph -> wheres $ c ! Columns.tableSchema' .=. ph)
            (nameP  , ()) <- placeholder (\ph -> wheres $ c ! Columns.tableName'   .=. ph)
            asc $ c ! Columns.ordinalPosition'
            return (schemaP >< nameP, c)

primaryKeyQuerySQL :: Query (String, String) String
primaryKeyQuerySQL =  relationalQuery primaryKeyRelation
    where
        primaryKeyRelation =  relation' $ do
            cons  <- query tableConstraints
            key   <- query keyColumnUsage
            col   <- query columns

            wheres $ cons ! Tabconst.tableSchema'    .=. col ! Columns.tableSchema'
            wheres $ cons ! Tabconst.tableName'      .=. col ! Columns.tableName'
            wheres $ key  ! Keycoluse.columnName'    .=. col ! Columns.columnName'
            wheres $ cons ! Tabconst.constraintName' .=. key ! Keycoluse.constraintName'

            wheres $ col  ! Columns.isNullable'      .=. value "NO"
            wheres $ cons ! Tabconst.constraintType' .=. value "PRIMARY KEY"

            (schemaP, ()) <- placeholder (\ph -> wheres $ cons ! Tabconst.tableSchema' .=. ph)
            (nameP  , ()) <- placeholder (\ph -> wheres $ cons ! Tabconst.tableName'   .=. ph)

            asc  $ key ! Keycoluse.ordinalPosition'

            return   (schemaP >< nameP, key ! Keycoluse.columnName')
