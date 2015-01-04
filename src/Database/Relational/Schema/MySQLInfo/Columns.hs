{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE FlexibleInstances #-}

module Database.Relational.Schema.MySQLInfo.Columns where

import Data.Int                     (Int16)
import Database.Record.TH           (derivingShow)
import Database.Relational.Query.TH (defineTableTypesAndRecordDefault)
import Database.Relational.Schema.MySQLInfo.Config (config)

$(defineTableTypesAndRecordDefault config
    "INFORMATION_SCHEMA" "columns"
    [ ("table_schema",      [t|String|])
    , ("table_name",        [t|String|])
    , ("column_name",       [t|String|])
    , ("ordinal_position",  [t|Int16|])
    , ("column_default",    [t|Maybe String|])
    , ("is_nullable",       [t|String|])
    , ("data_type",         [t|String|])
    ]
    [derivingShow])
