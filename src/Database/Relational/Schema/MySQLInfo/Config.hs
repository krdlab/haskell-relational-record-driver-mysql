module Database.Relational.Schema.MySQLInfo.Config (config) where

import Database.Relational.Query (Config(..), defaultConfig)

config :: Config
config = defaultConfig { normalizedTableName = False }
