//
//  GRDB-Swift2-ConversionHelper.swift
//  GRDB
//
//  Created by Swiftlyfalling.
//
//  Provides automatic renaming Fix-Its for many of the Swift 2.x -> Swift 3 GRDB API changes.
//  Consult the CHANGELOG.md and documentation for details on all of the changes.
//

import Foundation

@available(*, unavailable, renamed:"Database.ForeignKeyAction")
public typealias SQLForeignKeyAction = Database.ForeignKeyAction

@available(*, unavailable, renamed:"Database.ColumnType")
public typealias SQLColumnType = Database.ColumnType

@available(*, unavailable, renamed:"Database.ConflictResolution")
public typealias SQLConflictResolution = Database.ConflictResolution

@available(*, unavailable, renamed:"Database.CollationName")
public typealias SQLCollation = Database.CollationName

@available(*, unavailable, renamed:"SQLSpecificExpressible")
public typealias _SpecificSQLExpressible = SQLSpecificExpressible

@available(*, unavailable, renamed:"SQLExpression")
public typealias _SQLExpression = SQLExpression
