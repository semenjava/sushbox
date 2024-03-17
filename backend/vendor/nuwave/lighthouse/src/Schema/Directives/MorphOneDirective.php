<?php declare(strict_types=1);

namespace Nuwave\Lighthouse\Schema\Directives;

class MorphOneDirective extends RelationDirective
{
    public static function definition(): string
    {
        return /** @lang GraphQL */ <<<'GRAPHQL'
"""
Corresponds to [Eloquent's MorphOne-Relationship](https://laravel.com/docs/eloquent-relationships#one-to-one-polymorphic-relations).
"""
directive @morphOne(
  """
  Specify the relationship method name in the model class,
  if it is named different from the field in the schema.
  """
  relation: String

  """
  Apply scopes to the underlying query.
  """
  scopes: [String!]
) on FIELD_DEFINITION
GRAPHQL;
    }
}
