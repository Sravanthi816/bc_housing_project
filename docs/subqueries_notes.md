# Subqueries Notes

## Definition
A subquery is a query nested inside another SQL query.

## Scalar Subquery
A scalar subquery returns exactly one value.

Example:
- AVG()
- MAX()
- MIN()

## Execution Order
Usually:
1. Inner query executes first
2. Outer query uses returned result

## Common Use Cases
- Compare rows against averages
- Dynamic filtering
- Business analytics
- Nested conditions

## Important Difference
JOIN:
- combines tables

Subquery:
- compares rows against query results
